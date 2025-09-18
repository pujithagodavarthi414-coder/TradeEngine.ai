using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Bson;
using PDFHTMLDesignerCommon.Constants;
using PDFHTMLDesignerModels;
using PDFHTMLDesignerModels.DocumentModel.file;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerServices.PDFDocumentEditor
{
    public interface IFileUploadService
    {
        public Task<ActionResult> UploadFiles(string blobPath, string filetype, string filename);
        
    }
}
