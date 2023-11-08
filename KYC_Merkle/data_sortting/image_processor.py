from PIL import Image
import pytesseract
from urllib.request import urlopen
from io import BytesIO
import error_handler  # Assuming this is your custom error handling module

def load_image_from_url(url):
    """
    Loads an image from a given URL.
    """
    try:
        with urlopen(url) as response:
            data = response.read()
            return Image.open(BytesIO(data))
    except Exception as e:
        error_handler.handle(e)  # Handle errors appropriately

def load_image_from_file(file_path):
    """
    Loads an image from a file path.
    """
    try:
        return Image.open(file_path)
    except Exception as e:
        error_handler.handle(e)  # Handle errors appropriately

def convert_image_to_format(image, output_format='PNG'):
    """
    Converts an image to the specified format.
    """
    try:
        with BytesIO() as output:
            image.save(output, format=output_format)
            return output.getvalue()
    except Exception as e:
        error_handler.handle(e)  # Handle errors appropriately

def extract_text_from_image(image):
    """
    Uses OCR to extract text from an image.
    """
    try:
        text = pytesseract.image_to_string(image)
        return text
    except Exception as e:
        error_handler.handle(e)  # Handle errors appropriately

# Example of a main function to tie it all together
if __name__ == "__main__":
    # Example usage, replace with actual paths or URLs
    image_url = "http://example.com/image.jpg"
    image_file_path = "/path/to/your/image.jpg"

    # Load image from URL
    image = load_image_from_url(image_url)
    
    # Or load from file
    # image = load_image_from_file(image_file_path)

    # Convert image if necessary
    # image_data = convert_image_to_format(image)

    # Extract text if necessary
    # text = extract_text_from_image(image)

    # Further processing...
