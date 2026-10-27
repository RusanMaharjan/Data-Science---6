import streamlit as st
import pandas as pd
import plotly.express as px
from style import headerStyle, kpiStyle

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
# st.header(':yellow[KPI]')

# Sidebar
st.sidebar.header('Filter Data')

# Get Unique Categories
categories = sorted(df['pizza_category'].unique())
# Implement Unique categories into dropdown for selection
categories_data = st.sidebar.multiselect(
    'Pizza Category',
    options=categories,
    default=categories
)

# Get Unique Sizes
sizes = sorted(df['pizza_size'].unique())
# Implement Unique Sizes into dropdown for selection
sizes_data = st.sidebar.multiselect(
    'Pizza Size',
    options=sizes,
    default=sizes
)

# Filter Data
filtered = df[
    (df['pizza_category'].isin(categories_data))
    & (df['pizza_size'].isin(sizes_data))
]


if filtered.empty:
    st.warning('No data selected')
    st.stop()

# KPI
st.markdown(headerStyle('KPI'), unsafe_allow_html=True)

total_revenue = filtered['total_price'].sum()
total_pizza_sold = filtered['quantity'].sum()
total_orders = filtered['order_id'].nunique()
average_order_value = total_revenue / total_orders
average_pizza_per_order = total_pizza_sold / total_orders


kpi1, kpi2, kpi3, kpi4, kpi5 = st.columns(5)

with kpi1:
    st.markdown(kpiStyle('Total Revenue', f'${total_revenue:,.2f}'), 
                unsafe_allow_html=True)

with kpi2:
    st.markdown(kpiStyle('Total Pizza Sold', f'{total_pizza_sold:,.2f}'), 
                unsafe_allow_html=True)
    
with kpi3:
    st.markdown(kpiStyle('Total Orders', f'{total_orders:,.2f}'), 
                unsafe_allow_html=True)
    
with kpi4:
    st.markdown(kpiStyle('Average Order Value', f'${average_order_value:,.2f}'), 
                unsafe_allow_html=True)
    
with kpi5:
    st.markdown(kpiStyle('Average Pizza/Order', f'{average_pizza_per_order:,.2f}'), 
                unsafe_allow_html=True)

st.divider()

# Tabs for Visualization
tab_overview, tab_time, tab_top_bottom, raw_data = st.tabs(
    ['Overview', 'Time Analysis', 'Top/Bottom Sales', 'Raw Data']
)

with tab_overview:
    left, right = st.columns(2)
    
    with left:
        cat_sales_pct = filtered.groupby('pizza_category')['total_price'].sum().reset_index()
        
        fig = px.pie(
            cat_sales_pct,
            names='pizza_category',
            values='total_price',
            hole=0.7,
            labels={'pizza_category': 'Pizza Category', 'total_price': 'Revenue($)'},
            color_discrete_sequence=px.colors.sequential.BuPu_r
        )
        st.plotly_chart(fig, use_container_width=True)
        
    
    with right:
        size_cat_pct = filtered.groupby(['pizza_size', 'pizza_category'])['total_price'].sum().reset_index()
        
        fig = px.bar(
            size_cat_pct,
            x='pizza_size',
            y='total_price',
            color='pizza_category',
            barmode='group',
            labels={'pizza_size': 'Pizza Size', 'pizza_category': 'Pizza Category', 'total_price': 'Revenue($)'},
            color_discrete_sequence=px.colors.sequential.Blugrn_r
        )
        st.plotly_chart(fig, use_container_width=True)
        
        
    
with tab_time:
    st.write('Time')

with tab_top_bottom:
    st.write('Top and Bottom')

with raw_data:
    st.write('Data')