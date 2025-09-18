using MongoDB.Bson;
using PDFHTMLDesignerModels;
using PDFHTMLDesignerModels.DocumentModel.file;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerRepo.FileDataSet
{
    public interface IFileDataSetRepository
    {
        List<FileDatasetOutputModel> GetFileDataSetById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FileDatasetOutputModel> GetAllFileDataSet(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        FileDatasetOutputModel InsertFileDataSet(FileDatasetInputModel fileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpdateFileDataSet(string id, FileDatasetInputModel fileinputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string ArchiveFileById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<object> DeleteFileDatasetById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
