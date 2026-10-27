# Styling for Headers
def headerStyle(header):
    return f"""
        <div style='
            font-size: 2.2rem;
            font-weight: bold;
            font-family: cursive;
            color: #fff000;
            border-bottom: 1px solid #000fff;
            padding: 5px 10px;
            margin: 20px 0;
            display: inline-block;
        '>
            {header}
        </div>
    """

# Styling for KPIs
def kpiStyle(label:str, value:str):
    return f"""
        <div style='text-align: center; 
            border-left: 3px solid #fff000;
            border-bottom-left-radius: 5px;
            border-top-left-radius: 5px;
            margin: 10px 0 20px 0;'>
            <div style='font-size: 1rem;'>
                {label}
            </div>
            <div style='font-size: 0.99rem;
                    font-weight: bold'>
                {value}
            </div>
        </div>
    """
