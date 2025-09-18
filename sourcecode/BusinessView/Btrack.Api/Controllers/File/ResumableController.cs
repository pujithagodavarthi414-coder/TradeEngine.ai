using Btrak.Models;
using Btrak.Models.File;
using Btrak.Services.FileUpload;
using BTrak.Api.Controllers.Api;
using BTrak.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace BTrak.Api.Controllers.Fil
{
    public class FileUploadController : AuthTokenApiController
    {
        //[HttpPost]
        //[HttpOptions]
        //public object UploadFileOptions()
        //{
        //    return Request.CreateResponse(HttpStatusCode.OK);
        //}

        private readonly Btrak.Services.FileUpload.IFileService _fileService;

        public FileUploadController(IFileService fileService)
        {
            _fileService = fileService;
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.UploadFileChunks)]
        public object Upload(int resumableChunkNumber, string resumableIdentifier)
        {
            return ChunkIsHere(resumableChunkNumber, resumableIdentifier) ? Request.CreateResponse(HttpStatusCode.OK) : Request.CreateResponse(HttpStatusCode.NoContent);
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UploadFileChunks)]
        public async Task<object> Upload()
        {
            // Check if the request contains multipart/form-data.
            if (!Request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();
            if (!Directory.Exists(AppConstants.uploadFileChunkPath)) Directory.CreateDirectory(AppConstants.uploadFileChunkPath);
            var provider = new MultipartFormDataStreamProvider(AppConstants.uploadFileChunkPath);
            object fileIdReturned = await _fileService.UploadFile(provider, Request, LoggedInContext, validationMessages);

            if(validationMessages.Count > 0)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, validationMessages[0].ValidationMessaage);
            }

            return Request.CreateResponse(HttpStatusCode.OK, fileIdReturned);
        }

        [HttpPost]
        [HttpOptions]
        [Route("File/FileApi/UploadFromDrive")]
        public async Task<object> UploadFromDrive(List<DriveFile> files)
        {
            // Check if the request contains multipart/form-data.
            //if (!Request.Content.IsMimeMultipartContent())
            //{
            //    throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            //}
            //var fileList = JsonConvert.DeserializeObject(files.ToString());
            try
            {
                if (!Directory.Exists(AppConstants.uploadFileChunkPath)) Directory.CreateDirectory(AppConstants.uploadFileChunkPath);
                var provider = new MultipartFormDataStreamProvider(AppConstants.uploadFileChunkPath);
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                var fileData = new List<FileResult>();
                if (files.Count > 0)
                {
                    foreach (var f in files)
                    {
                        WebClient wb = new WebClient();
                        if (f.WebContentLink != null)
                        {
                            wb.DownloadFile(f.WebContentLink, AppConstants.uploadFileChunkPath + "/" + f.Name);
                        }
                        //else
                        //{
                        //    wb.DownloadFile("https://drive.google.com/uc?id=" + f.Id + "&export=download", AppConstants.uploadFileChunkPath + "/" + f.Name);
                        //}
                        var path = AppConstants.uploadFileChunkPath + "/" + f.Name;
                        if (File.Exists(path))
                        {
                            //FileStream fileStream = File.OpenRead(path); // or
                            //TextReader textReader = File.OpenText(path); // or
                            //StreamReader sreamReader = new StreamReader(path);
                            FileResult file = await _fileService.ReadPart(f, provider, path, LoggedInContext, validationMessages);
                            fileData.Add(file);
                        }
                    }
                }


                //object fileIdReturned = await _fileService.UploadFile(provider, Request, LoggedInContext, validationMessages);

                if (validationMessages.Count > 0)
                {
                    return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, validationMessages[0].ValidationMessaage);
                }

                return Request.CreateResponse(HttpStatusCode.OK, fileData);
            }
            catch(Exception e)
            {
                return null;
            }
        }

        #region Chunk methods

        [NonAction]
        private string GetChunkFileName(int chunkNumber, string identifier)
        {
            return Path.Combine(AppConstants.uploadFileChunkPath, string.Format("{0}_{1}", identifier, chunkNumber.ToString()));
        }
        
        [NonAction]
        private bool ChunkIsHere(int chunkNumber, string identifier)
        {
            string fileName = GetChunkFileName(chunkNumber, identifier);
            return File.Exists(fileName);
        }

        #endregion

    }
}