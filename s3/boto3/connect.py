import boto3
import logging
from pathlib import Path
from boto3.session import Session

session = Session(profile_name="psgpyceltify")

s3c = session.client("s3")

def upload_file_to_s3(file_name, bucket, prefix=None):
    if file_name.exists():
        if prefix:
            object_name = f"{prefix}/{file_name.name}"
        else:
            object_name = file_name.name

        with open(file_name, 'rb') as f:
            s3c.upload_fileobj(f, bucket, object_name)
    else:
        raise FileNotFoundError("The file doesnot exists")


# upload_file_to_s3(file_name="AR_AWD_22072247_1_04.pdf", bucket="psgpyc-t-source-bucket-xxx")

def upload_folder_content_to_s3(folder_path, bucket, prefix=None):
    if folder_path.exists():
        for file in folder_path.iterdir():
            if file.suffix == ".pdf":
                try:
                    upload_file_to_s3(file_name=file, bucket=bucket, prefix=prefix)
                except FileNotFoundError as e:
                    logging.error(f"An error occured while uploading the file: {file}. [{e}]")
    else:
        raise FileNotFoundError
    
if __name__ == "__main__":
    folder = Path('/Users/psgpyc/Downloads/')
    bucket_name = "psgpyc-t-source-bucket-xxx"
    upload_folder_content_to_s3(folder_path=folder, bucket=bucket_name, prefix="pdf")