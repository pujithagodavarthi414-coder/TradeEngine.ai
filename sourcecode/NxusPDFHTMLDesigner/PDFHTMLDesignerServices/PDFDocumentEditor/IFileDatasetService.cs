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
    public interface IFileDatasetService
    {
        public List<FileDatasetOutputModel> GetAllFileDataSet(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public List<FileDatasetOutputModel> GetFileDataSetById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public FileDatasetOutputModel InsertFileDataSet(FileDatasetInputModel fileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public string UpdateFileDataSet(string id, FileDatasetInputModel fileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public string ArchiveFileById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<object> DeleteFileDatasetById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
