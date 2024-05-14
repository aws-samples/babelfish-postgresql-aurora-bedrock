import streamlit as st
import pandas as pd
import pyodbc
import json
import boto3
from botocore.exceptions import ClientError
import secrets

#replace the secret_name and region_name with AWS secret manager where your credentials are stored
def get_secret():
    sm_key_name = 'MyTestSecret' #eg: 'aurorapg-db-credentials'
    region_name = "us-east-1"
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )
    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=sm_key_name
        )
    except ClientError as e:
        print(e)
    secret = get_secret_value_response['SecretString']
    return secret

#Run query on Babelfish for Amazon Aurora PostgreSQL, using ODBC Driver and pyodbc
def run_query(conn, query):
    with conn.cursor() as cur:
        conn.autocommit = True
        cur.execute(query)        
        return cur.fetchall()

# Display additional search results
def write_columns_data(result):
    col1, col2, col3 = st.columns(3)
    cols = [ col1, col2, col3 ]
    for x in range(3):
        cols[x].text(result[x+1][1])
    return

def main():
    st.title(':orange[Hotel Search Demo :hotel:]')
    query = st.text_input('Search for a hotel')
    if query:
        with pyodbc.connect("DRIVER={ODBC Driver 18 for SQL Server};SERVER=" + dbhost + ";DATABASE=" + dbname + ";Port=1433;TrustServerCertificate=yes;UID=" + dbuser+ ";PWD=" + dbpass) as dbconn:
            st.divider()
            st.subheader(':gray[Top Matching Hotels:]')
            result=run_query(dbconn, ("EXEC hotel.ss_get_top5_hotels '{}'".format(query)))
            col1, col2, col3 = st.columns(3)
            with col1:
                st.subheader("Hotel Name")
                st.write(result[0][1])
            with col2:
                st.subheader("Details")
                st.write(result[0][3])
            with col3:
                st.subheader("Summary of user reviews")
                res=run_query(dbconn, ("EXEC hotel.ss_get_reviews_summary {}".format(result[0][0] )))
                
                if res:
                    response_json= json.loads(res[0][0])
                    st.write( response_json["completion"].replace(' Here is a summary of the key points from the text:\n\n-', '') )
            st.divider()
            st.subheader('Top 3 Recommended Hotels:')
            with st.container():
                write_columns_data(result)
        st.divider()
        
if __name__ == '__main__':

    dbname='master'
    secret = json.loads(get_secret())

    dbhost=secret["host"]
    dbuser=secret["username"]
    dbpass=secret["password"]

    main()

