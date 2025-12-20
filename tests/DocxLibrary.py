from docx import Document
from docx.shared import Inches
import os

class DocxLibrary:
    """Custom library for creating DOCX files with screenshots."""
    
    def create_screenshots_document(self, img1_path, caption1, img2_path, caption2, output_path):
        """Creates DOCX with two screenshots and captions."""
        if not os.path.exists(img1_path):
            raise AssertionError(f"Image not found: {img1_path}")
        if not os.path.exists(img2_path):
            raise AssertionError(f"Image not found: {img2_path}")
            
        doc = Document()
        doc.add_heading('Screenshots Report', 0)
        
        # Add first screenshot
        doc.add_heading(caption1, level=1)
        doc.add_picture(img1_path, width=Inches(6))
        
        # Add second screenshot
        doc.add_heading(caption2, level=1)
        doc.add_picture(img2_path, width=Inches(6))
        
        doc.save(output_path)
