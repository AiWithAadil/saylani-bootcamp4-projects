import sys
import boto3
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql.functions import *
from pyspark.sql.types import *
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
input_path = "s3://bootcamp-task1-ad/raw-data/"
output_path = "s3://bootcamp-task1-ad/processed-data/"
# Load data
df = spark.read.csv(input_path, header=True, inferSchema=True)
print(f"Original records: {df.count()}")
# Standardize column names
for col_name in df.columns:
    df = df.withColumnRenamed(col_name, col_name.lower().strip().replace(" ", "_"))
print("Columns:", df.columns)
# Drop duplicates
df = df.dropDuplicates()
# Drop rows where important columns are null
df = df.dropna(subset=["invoiceno", "stockcode", "quantity", "unitprice"])
# Remove outliers - negative quantity and price
df = df.filter(col("quantity") > 0)
df = df.filter(col("unitprice") > 0)
# Fix data types
df = df.withColumn("quantity", col("quantity").cast(IntegerType()))
df = df.withColumn("unitprice", col("unitprice").cast(FloatType()))
# Convert date and format for Redshift
df = df.withColumn("invoicedate", to_timestamp(col("invoicedate"), "M/d/yyyy H:mm"))
df = df.withColumn("invoicedate", date_format(col("invoicedate"), "yyyy-MM-dd HH:mm:ss"))
# Fix customerid - remove .0 and handle nulls
df = df.withColumn("customerid", regexp_replace(col("customerid").cast(StringType()), "\.0$", ""))
df = df.withColumn("customerid", when(col("customerid").isNull() | (col("customerid") == ""), "UNKNOWN").otherwise(col("customerid")))
# Calculate total_sales
df = df.withColumn("total_sales", col("quantity") * col("unitprice"))
# Clean all string columns - remove quotes and problematic chars
df = df.withColumn("description", regexp_replace(col("description"), '"', ''))
df = df.withColumn("description", regexp_replace(col("description"), ',', ' '))
df = df.withColumn("description", regexp_replace(col("description"), '\t', ' '))
df = df.withColumn("country", regexp_replace(col("country"), '"', ''))
df = df.withColumn("country", regexp_replace(col("country"), ',', ' '))
df = df.withColumn("country", regexp_replace(col("country"), '\t', ' '))
# Data Quality Checks
total = df.count()
null_invoice = df.filter(col('invoiceno').isNull()).count()
null_customer = df.filter(col('customerid').isNull()).count()
negative_qty = df.filter(col('quantity') <= 0).count()
negative_price = df.filter(col('unitprice') <= 0).count()
print(f"Total records: {total}")
print(f"Null invoiceno: {null_invoice}")
print(f"Null customerid: {null_customer}")
print(f"Negative quantity: {negative_qty}")
print(f"Negative price: {negative_price}")
if null_invoice > 0 or negative_qty > 0 or negative_price > 0:
    raise Exception("Data Quality Check Failed!")
# Validate
print(f"Null invoiceno: {df.filter(col('invoiceno').isNull()).count()}")
print(f"Null quantity: {df.filter(col('quantity').isNull()).count()}")
print(f"Null customerid: {df.filter(col('customerid').isNull()).count()}")
print(f"Clean records: {df.count()}")
# Save as tab-separated to avoid quote issues
df.coalesce(1).write.mode("overwrite").option("header", True).option("sep", "\t").csv(output_path)
print("ETL completed successfully!")