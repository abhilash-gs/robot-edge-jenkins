from docx import Document
from docx.shared import Inches
import os

class DocxLibrary:
    """Fixed DOCX library - Direct string arguments."""
    
    def create_screenshots_document(self, output_path, *args):
        print(f"📋 Processing {len(args)//2} screenshots")
        
        if len(args) % 2 != 0:
            raise AssertionError(f"Expected image+caption pairs. Got {len(args)} args")
        
        doc = Document()
        doc.add_heading('Screenshots Report', 0)
        doc.add_paragraph(f'Generated on: {os.path.basename(output_path)}')
        doc.add_paragraph('')
        
        for i in range(0, len(args), 2):
            img_path = args[i]
            caption = args[i + 1]
            
            print(f"  📸 Adding: {os.path.basename(img_path)}")
            
            if not os.path.exists(img_path):
                print(f"❌ Files in dir: {os.listdir(os.path.dirname(img_path))}")
                raise AssertionError(f"Image not found: {img_path}")
            
            doc.add_heading(caption, level=1)
            doc.add_picture(img_path, width=Inches(6.5))
            doc.add_paragraph('')
        
        doc.save(output_path)
        print(f"✅ DOCX SAVED: {output_path}")
        return output_path
