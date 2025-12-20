from docx import Document
from docx.shared import Inches
import os

class DocxLibrary:
    """Dynamic DOCX library for Robot Framework - Unlimited screenshots."""
    
    def create_screenshots_document(self, output_path, *args):
        """
        Dynamic screenshots: output_path, img1, caption1, img2, caption2, ...
        Supports @{list} from Robot Framework perfectly.
        """
        print(f"DEBUG: Received {len(args)} arguments ({len(args)//2} screenshots)")
        
        # Validate even number of arguments (image + caption pairs)
        if len(args) % 2 != 0:
            raise AssertionError(f"Expected even number of args (image+caption pairs). Got {len(args)}")
        
        # Create directory if needed
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        
        doc = Document()
        doc.add_heading('Screenshots Report', 0)
        doc.add_paragraph(f'Generated: {os.path.basename(output_path)}')
        doc.add_paragraph('')  # Spacing
        
        # Process all screenshot pairs
        for i in range(0, len(args), 2):
            img_path = args[i]
            caption = args[i + 1]
            
            print(f"  📸 Adding: {os.path.basename(img_path)} - {caption}")
            
            if not os.path.exists(img_path):
                raise AssertionError(f"❌ Image missing: {img_path}")
            
            # Add heading and image
            doc.add_heading(caption, level=1)
            doc.add_picture(img_path, width=Inches(6.5))
            doc.add_paragraph('')  # Spacing between screenshots
        
        # Save document
        doc.save(output_path)
        print(f"✅ SUCCESS: DOCX saved to {output_path}")
        return output_path
