

import vt
import hashlib


# Function to calculate the hash of the file
def calculate_hash(file_path, hash_type='sha256'):
    h = hashlib.new(hash_type)
    with open(file_path, 'rb') as file:
        while chunk := file.read(4096):
            h.update(chunk)
    return h.hexdigest()

# Function to get the file report from VirusTotal
def get_file_report(api_key, file_path):
    file_hash = calculate_hash(file_path)  # Ensure the hash is calculated
    
    with vt.Client(api_key) as client:
        file = client.get_object(f"/files/{file_hash}")

        for key, value in file.to_dict().items():
           print(f"{key}: {value}")

        
        # Check for optional attributes
        pe_info = file.get('pe_info')
        if pe_info:
            print("PE Info:", pe_info)

if __name__ == "__main__":
    api_key = '4fe8a3a6a41b79ced5a55201e606fe074d93105ac1570b9f61395b7b8d16a1f6'
    file_path = '/Users/giovannibattistapernazza/Downloads/logo-verde.png'
    get_file_report(api_key, file_path)

