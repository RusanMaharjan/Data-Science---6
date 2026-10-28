import joblib

LOGISTIC_MODEL_PATH = 'Cardio/models/logistics/logistic_model.pkl'
LOGISTIC_SCALER_PATH = 'Cardio/models/logistics/logistic_scaler.pkl'

SVM_MODEL_PATH = 'Cardio/models/svm/svm_model.pkl'
SVM_SCALER_PATH = 'Cardio/models/svm/svm_scaler.pkl'


def read_logistic():
    model = joblib.load(LOGISTIC_MODEL_PATH)
    scaler = joblib.load(LOGISTIC_SCALER_PATH)
    
    return model, scaler

def read_svm():
    model = joblib.load(SVM_MODEL_PATH)
    scaler = joblib.load(SVM_SCALER_PATH)
    
    return model, scaler