import streamlit as st
import pandas as pd
from style import headerStyle

# Read Data
@st.cache_data
def load_data(path:str) -> pd.DataFrame:
    df = pd.read_csv(path)
    return df

# Clean Data and Feature Engineering
@st.cache_data
def clean_data(df:pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df["order_date"] = pd.to_datetime(df["order_date"], format="mixed")
    df["order_time"] = pd.to_datetime(df["order_time"], format="mixed").dt.time

    # Feature engineering
    df["Order_Day"] = df["order_date"].dt.day_name()
    df["Order_Month"] = df["order_date"].dt.month_name()
    df["month_num"] = df["order_date"].dt.month
    df["Order_Hour"] = pd.to_datetime(df["order_time"], format="%H:%M:%S").dt.hour

    # Categorical ordering so plots sort correctly
    weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday",
                "Thursday", "Friday", "Saturday"]
    df["Order_Day"] = pd.Categorical(df["Order_Day"], categories=weekdays, ordered=True)

    months = ["January", "February", "March", "April", "May", "June",
              "July", "August", "September", "October", "November", "December"]
    df["Order_Month"] = pd.Categorical(df["Order_Month"], categories=months, ordered=True)

    return df

# Read Data using Functions
df_raw = load_data('pizza_sales.csv')
df = clean_data(df_raw)

# Page Configuration
st.set_page_config(
    page_title='Pizza Sales Dashboard',
    page_icon=':pizza:',
    layout='wide',
    initial_sidebar_state='expanded'
)

st.title('Pizza Sales Dashboard')
st.header(':yellow[KPI]')

st.markdown(headerStyle('KPI'), unsafe_allow_html=True)

st.markdown(headerStyle('Analysis'), unsafe_allow_html=True)

st.header('Raw Data')