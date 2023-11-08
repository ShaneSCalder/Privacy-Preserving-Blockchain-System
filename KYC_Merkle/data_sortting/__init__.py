# __init__.py

from .text_processor import TextProcessor
from .image_processor import ImageProcessor
from .pdf_processor import PDFProcessor
from .error_handler import ErrorHandler

__all__ = ['TextProcessor', 'ImageProcessor', 'PDFProcessor', 'ErrorHandler']


#still need to add path to each file.