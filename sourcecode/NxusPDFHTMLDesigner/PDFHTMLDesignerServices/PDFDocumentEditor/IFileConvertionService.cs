using Azure.Storage.Blobs;
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
    public interface IFileConvertionService
    {
        public string ConvertSFDTToHTML(string blobPath, string filetype, string filename, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public Task UploadStream(BlobContainerClient containerClient, string localFilePath);
        Task<string> ConvertSFDTToHTMLFileAsync(string blobPath, string filetype, string filename, LoggedInContext loggedInContext);
    }
}
