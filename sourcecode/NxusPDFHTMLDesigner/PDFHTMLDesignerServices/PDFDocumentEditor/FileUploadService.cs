using PDFHTMLDesignerCommon.Constants;
using PDFHTMLDesignerServices.PDFDocumentEditor;
using Microsoft.AspNetCore.Mvc;
using PDFHTMLDesignerModels.SFDTParameterModel;
using Microsoft.Extensions.Configuration;
using System.Threading.Tasks;
using System;
using System.IO;
using System.Net;
using PDFHTMLDesigner.EditorConstants;
using Syncfusion.Pdf;
using Syncfusion.HtmlConverter;
using System.Net.Http;
using MongoDB.Driver;
using System.Net.Http.Headers;
using MongoDB.Bson.IO;
using PDFHTMLDesignerModels;
using Microsoft.AspNetCore.Http;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Text;
using System.Configuration;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;

namespace PDFHTMLDesignerServices.DocumentEditor
{
    public class FileUploadService : IFileUploadService
    {
        IConfiguration _iconfiguration;

        public FileUploadService(IConfiguration iConfiguration)
        {
            _iconfiguration = iConfiguration;
        }

        public async Task<ActionResult> UploadFiles(string blobPath, string filetype, string filename)
        {
            string Baseurl = "https://documentstorageservice.sgt1dev.nxusworld.com/";//https://localhost:44384/";
                Guid? parentId = null;
          
            using (var client = new HttpClient())
            {
                string accessToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjJDREQ2RkIzMUY0MEE5REFCNjZEQTlDOTM1NzhCNEFFIiwidHlwIjoiYXQrand0In0.eyJuYmYiOjE2NjM2NTU2MjQsImV4cCI6MTY2MzY2MjgyNCwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo1ODMwMyIsImNsaWVudF9pZCI6Ijg0MDU0OTRGLTRCQkEtNDk2Qi05RTc3LTJDQkJFMzA4RjgzNCAzM0YzNEQ3Ny0yNjExLTRERTctQkExOS0xN0IzRDRBODFCNDYiLCJqdGkiOiIxNzZCRTJGNEU2MjVFQ0IzQjEzNzNERTg5M0M3OTY1MiIsImlhdCI6MTY2MzY1NTYyNCwic2NvcGUiOlsiMzNGMzRENzctMjYxMS00REU3LUJBMTktMTdCM0Q0QTgxQjQ2Il19.BF-pUV7ncqBHk0qrdxqNGc4U1nlBD1OhgeuQQ15UEX7SV2zJc2cTXjP15JU3unsxMQeJScxTc40CNld8JuG8gFfQc5mHYNyVylgBuaiCUDiII3IuiqncrGS3JndXfhm5tSRdq9y5jys7emAtWjAtfCWQeUH-_aA4xYwXhbHjjNUtNHBNc1RyZgDfw6mERaH1vr3aA37cif0Tj3Hr-rO74_HoFG5ycwCTMGzcu3MiKzYtDkMNwrnR2V2p_E085LgSJVHIa4Czoz080Q6Tk9_os1kixuCTxXEgdPjClPT0sA68OfKt6C2d-yWJIyHIXwyYzI7GGRuvltRK33CpFezzBA";
                client.BaseAddress = new Uri(Baseurl + "File/FileApi/UploadFileChunks");
                client.DefaultRequestHeaders.Add("Authorization","Bearer " + accessToken);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                UploadFileToBlobInputModel uploadFileToBlobInputModel = new UploadFileToBlobInputModel
                {
                    LocalFilePath = "file:///E:/Projects/Nxus/sourcecode/NxusPDFHTMLDesigner/PDFHTMLDesigner/ConvertedFiles/1675319197072_sample.pdf",
                    //LocalFilePath = "file:///E:/Projects/Nxus/sourcecode/NxusPDFHTMLDesigner/PDFHTMLDesigner/ConvertedFiles/1675250967855_Test123.html",
                    FileName = "1675319197072_sample.pdf",
                    ModuleTypeId = 1,
                    ContentType = "Application/pdf",
                    ParentDocumentId = new Guid("a6c23d32-6e08-4431-a0c8-d5ceb29cf21a")
                };
                HttpResponseMessage response = new HttpResponseMessage();
                HttpContent httpContent = new StringContent(Newtonsoft.Json.JsonConvert.SerializeObject(uploadFileToBlobInputModel), Encoding.UTF8, "application/json");
                response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                return null;
            }
        }

        public async Task UploadFilesChunk(IFormFile file, int id, int moduleTypeId, string fileName, string contentType, Guid? parentDocumentId, LoggedInContext loggedInContext, IHttpContextAccessor httpContextAccessor, List<ValidationMessage> validationMessages)
        {
            string Baseurl = "https://localhost:44389/";
           
            using (var client = new HttpClient())
            {
                //Passing service base url      
                client.BaseAddress = new Uri(Baseurl);
                client.DefaultRequestHeaders.Clear();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                //Sending request to find web api REST service resource GetDepartments using HttpClient  
                HttpResponseMessage Res = await client.GetAsync("File/FileApi/UploadFileChunks");
                //return null;
            }
        }
    }
}
