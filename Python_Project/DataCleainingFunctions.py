import numpy as np

def stats(dataframe) :
    """Returns informations about dataset - shape and data types"""
    print('### Shape ###')
    print(f'Rows: {dataframe.shape[0]}')
    print(f'Columns: {dataframe.shape[1]}')
    print('\n')
    print('### Data Types ###')
    print(dataframe.dtypes)
    print('\n')

def miss_dupl(dataframe) :
    """Return information about missing values and duplicates in dataset"""
    print('\n')
    print('### Missing Values ###')
    print(dataframe.isna().sum())
    print('\n')
    print('### Duplicate Values ###')
    print(dataframe.duplicated().sum())
    print('\n')
    print('### Unique Values ###')
    print(dataframe.nunique().sum())

def drop_treshold(dataframe) :
    """ Return infrmation which column is in drop treshold of 5% missing values"""
    tresh = int(len(dataframe) * 0.05)
    return dataframe.columns[dataframe.isna().sum() <= tresh]

def dataset_IQR(col) :
    """ Calculate IQR for given column """
    return np.quantile(col, 0.75) - np.quantile(col, 0.25)

def lower_tresh(col):
   """ Calculate lower treshold """ 
   return np.quantile(col, 0.25) - 1.5 * dataset_IQR(col)

def upper_tresh(col) :
    """ Calculate upper treshold """
    return np.quantile(col, 0.75) + 1.5 * dataset_IQR(col)