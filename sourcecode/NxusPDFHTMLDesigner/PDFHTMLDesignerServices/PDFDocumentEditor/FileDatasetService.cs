using MongoDB.Bson;
//using MongoDB.Bson.IO;
using PDFHTMLDesignerCommon.Constants;
using PDFHTMLDesignerModels;
using PDFHTMLDesignerModels.DocumentModel.file;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using PDFHTMLDesignerRepo.FileDataSet;
using PDFHTMLDesignerServices.PDFDocumentEditor;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace PDFHTMLDesignerServices.DocumentEditor
{
    public class FileDatasetService : IFileDatasetService
    {
        private readonly IFileDataSetRepository _fileDataSetRepository;
       
        public FileDatasetService(IFileDataSetRepository iFileDataSetRepository)
        {
            _fileDataSetRepository = iFileDataSetRepository;
        }
        public List<FileDatasetOutputModel> GetAllFileDataSet(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ShowAllPDFMenu", "FileDatasetService"));
            return _fileDataSetRepository.GetAllFileDataSet(loggedInContext, validationMessages);
        }

        public List<FileDatasetOutputModel> GetFileDataSetById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        { 
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ShowFileDataSetById", "FileDatasetService"));
            return _fileDataSetRepository.GetFileDataSetById(id, loggedInContext, validationMessages);
        }

        public string ArchiveFileById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteFileById", "FileDatasetService"));
            return _fileDataSetRepository.ArchiveFileById(id, loggedInContext, validationMessages);
        }

        public Task<object> DeleteFileDatasetById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteFileDatasetById", "FileDatasetService"));
            return _fileDataSetRepository.DeleteFileDatasetById(id, loggedInContext, validationMessages);
        }

        public FileDatasetOutputModel InsertFileDataSet(FileDatasetInputModel fileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertFileDataSet", "FileDatasetService"));
            return _fileDataSetRepository.InsertFileDataSet(fileInputModel, loggedInContext, validationMessages);
        }

        public string UpdateFileDataSet(string id, FileDatasetInputModel fileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateFileDataSet", "FileDatasetService"));
            if (id == null)
            {
                return null;
            }
            return _fileDataSetRepository.UpdateFileDataSet(id, fileInputModel, loggedInContext, validationMessages);
        }


    }
}
