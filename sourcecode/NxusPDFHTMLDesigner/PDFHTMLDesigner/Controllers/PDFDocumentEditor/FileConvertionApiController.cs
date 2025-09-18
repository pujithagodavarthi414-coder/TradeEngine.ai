using PDFHTMLDesigner.Controllers;
using System;
using System.IO;
using System.Net;
using Microsoft.AspNetCore.Mvc;
using PDFHTMLDesignerCommon.Constants;
using Syncfusion.Pdf;
using Syncfusion.HtmlConverter;
using PDFHTMLDesigner.EditorConstants;
using PDFHTMLDesignerModels.SFDTFileConvertionModel;
using Microsoft.AspNetCore.Cors;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Microsoft.Extensions.Configuration;
using PDFHTMLDesigner.Models;
using System.Collections.Generic;
using PDFHTMLDesignerModels;
using PDFHTMLDesignerServices.PDFDocumentEditor;
using PDFHTMLDesigner.Helpers;
using PDFHTMLDesignerModels.SFDTParameterModel;
using Syncfusion.DocIO.DLS;
using Syncfusion.DocIORenderer;
using Syncfusion.DocIO;
using EJ2DocumentEditor = Syncfusion.EJ2.DocumentEditor;
using System.Text;

namespace PDFHTMLDesignerServices.DocumentEditor.Controllers
{
    [ApiController]
    public class FileConvertionController : AuthTokenApiController
    {
        IConfiguration _iconfiguration;
        private readonly IFileConvertionService _fileConvertionService;
        private readonly IFileUploadService _fileUploadService;
        DataJsonResult dataJsonResult;
        public FileConvertionController(IConfiguration iConfiguration, IFileConvertionService iFileConvertionService, IFileUploadService iFileUploadService)
        {
            _iconfiguration = iConfiguration;
            _fileConvertionService = iFileConvertionService;
            _fileUploadService = iFileUploadService;
        }

        [HttpPost]
        [Route(RouteConstants.UploadFiles)]
        public async Task<ActionResult> UploadFiles(string blobPath, string filetype, string filename)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UploadFiles", "FileDataSetApi"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                var doc = await _fileUploadService.UploadFiles(blobPath, filetype, filename);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UploadFiles", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UploadFiles", "FileDataSetApi"));
                return Json(new DataJsonResult { Data = doc, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFiles", "FileDataSetApi", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }

        }

        [HttpPost]
        [Route(RouteConstants.PreviewFileHTML)]
        
        public JsonResult PreviewFileHTML(SFDTParameter sFDTParameter)
        {
            try
            {
                byte[] doc = sFDTParameter.sfdtString;
                Stream stream = new MemoryStream(doc);
                stream.Position = 0;
                string json, htmljson="";
                
                StreamReader reader = new StreamReader(stream);
                json = reader.ReadToEnd();
                reader.Dispose();
                if (sFDTParameter.filetype=="html")
                {
                    Stream document = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(json, Syncfusion.EJ2.DocumentEditor.FormatType.Html);
                    StreamReader htmlreader = new StreamReader(document);
                    htmljson = htmlreader.ReadToEnd();
                    document.Close();
                    stream.Dispose();
                    htmlreader.Dispose();
                    return Json(new DataJsonResult { Data = htmljson, Success = true });
                }
                if (sFDTParameter.filetype=="doc")
                {
                    // Converts the sfdt to stream
                    Stream document = EJ2DocumentEditor.WordDocument.Save(json, EJ2DocumentEditor.FormatType.Docx);
                    Syncfusion.DocIO.DLS.WordDocument worddoc = new Syncfusion.DocIO.DLS.WordDocument(document, Syncfusion.DocIO.FormatType.Docx);
                    //Instantiation of DocIORenderer for Word to PDF conversion 
                    StreamReader pdfreader = new StreamReader(document);
                    json = pdfreader.ReadToEnd();
                    byte[]  mainBuffer = Encoding.ASCII.GetBytes(json);
                    document.Close();
                    stream.Dispose();
                    worddoc.Dispose();
                    return Json(new DataJsonResult { Data = mainBuffer, Success = true });

                }
                if (sFDTParameter.filetype == "pdf")
                {
                    Stream document = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(json, Syncfusion.EJ2.DocumentEditor.FormatType.Html);
                    StreamReader htmlreader = new StreamReader(document);
                    htmljson = htmlreader.ReadToEnd();
                    //Initialize HTML to PDF converter.
                    HtmlToPdfConverter htmlConverter = new HtmlToPdfConverter();
                    //HTML string and Base URL.
                    string htmlText = htmljson;
                    string baseUrl = @"C:/Temp/HTMLFiles/";
                    //Convert URL to PDF.
                    PdfDocument pdfdocument = htmlConverter.Convert(htmljson, baseUrl);
                    //StreamReader htmlreader = new StreamReader(document);
                    FileStream fileStream = new FileStream("HTML-to-PDF.pdf", FileMode.CreateNew, FileAccess.ReadWrite);
                    StreamReader pdfreader = new StreamReader(fileStream);
                    string pdfjson = pdfreader.ReadToEnd();
                    byte[] mainBuffer = Encoding.ASCII.GetBytes(json);
                    //Save and close the PDF document.
                    pdfdocument.Save(fileStream);
                    byte[] sfdtBytes = Convert.FromBase64String(pdfjson);
                    pdfreader = new StreamReader(fileStream);
                    pdfjson = pdfreader.ReadToEnd();
                    pdfdocument.Close(true);
                    document.Close();
                    stream.Dispose();
                    htmlreader.Dispose();
                }
                return Json(new DataJsonResult { Data = htmljson, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateFileDataSet", "FileDataSetApi", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [Route(RouteConstants.ConvertSFDTToHTML)]
        
        public JsonResult ConvertSFDTToHTML(string blobPath, string filetype, string filename)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ConvertSFDTToHTML", "FileDataSetApi"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                var doc = _fileConvertionService.ConvertSFDTToHTML(blobPath, filetype, filename, LoggedInContext, validationMessages);
                
                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteFileDatasetById", "FileApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ConvertSFDTToHTML", "FileDataSetApi"));
                return Json(new DataJsonResult { Data = doc, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ConvertSFDTToHTML", "FileDataSetApi", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [Route(RouteConstants.ConvertSFDTToHTMLFile)]
        
        public async Task<JsonResult> ConvertSFDTToHTMLFile(string blobPath, string filetype, string filename)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ConvertSFDTToHTMLFile", "FileConvertionApi"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                string fileName = await _fileConvertionService.ConvertSFDTToHTMLFileAsync(blobPath, filetype, filename, LoggedInContext);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ConvertSFDTToHTMLFile", "FileConvertionApi"));
                return Json(new DataJsonResult { Data = fileName, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ConvertSFDTToHTMLFile", "FileConvertionApi", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [Route("ConvertHTMLToPDF")]
        
        public JsonResult ConvertHTMLToPDF(string blobPath, string filetype, string filename)
        {
            try
            {
                //Initialize HTML to PDF converter.
                HtmlToPdfConverter htmlConverter = new HtmlToPdfConverter();
                BlinkConverterSettings blinkConverterSettings = new BlinkConverterSettings();

                //Set Blink viewport size.
                blinkConverterSettings.ViewPortSize = new Syncfusion.Drawing.Size(1280, 0);

                //Assign Blink converter settings to HTML converter.
                htmlConverter.ConverterSettings = blinkConverterSettings;
                var unixDateTime = DateTimeOffset.Now.ToUnixTimeMilliseconds();

                //Convert URL to PDF document.
                DirectoryInfo dirInfofile = new DirectoryInfo(EditorConstants.FileDirectory + "\\" + unixDateTime + "_" + filename);
                string passfilename = dirInfofile.Name;
                PdfDocument document = htmlConverter.Convert(blobPath);

                //Create a filestream.
                FileStream fileStream = new FileStream(dirInfofile.FullName + filetype, FileMode.CreateNew, FileAccess.ReadWrite);

                //Save and close the PDF document.
                document.Save(fileStream);
                document.Close(true);
                fileStream.Dispose();
                string filelocation = dirInfofile.FullName + filetype;
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ConvertHTMLToPDF", "FileDataSetApi"));
                return Json(new DataJsonResult { Data = filelocation, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ConvertHTMLToPDF", "FileDataSetApi", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [Route(RouteConstants.SFDTFileSave)]
        public JsonResult SFDTFileSave(SFDTFileConvertionModel convertionModel)
        {
            try
            {
                var unixDateTime = DateTimeOffset.Now.ToUnixTimeMilliseconds();
                DirectoryInfo dirInfofile = new DirectoryInfo(EditorConstants.FileDirectory + "\\" + unixDateTime + "_" + convertionModel.filename);
                string passfilename = dirInfofile.Name;
                string strm = convertionModel.fileStreamBase64;
                string path = dirInfofile.FullName;
                string filepath = "", Dbpath = "";

                if (convertionModel.filetype == ".sfdt")
                {
                    strm = strm.Replace("data:text/plain;base64,", String.Empty);
                    filepath = path + "\\" + passfilename + ".sfdt";
                    var bytess = Convert.FromBase64String(strm);
                    using (var imageFile = new FileStream(filepath, FileMode.Create))
                    {
                        imageFile.Write(bytess, 0, bytess.Length);
                        imageFile.Flush();
                        convertionModel.filetype = "sfdt save";
                        unixDateTime = DateTimeOffset.Now.ToUnixTimeMilliseconds();
                        Dbpath = path + "\\" + passfilename;
                        filepath = passfilename;
                        return Json(new DataJsonResult { Data = filepath, Success = true });
                    }
                }
                return null;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ConvertHTMLToPDF", "FileDataSetApi", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [Route(RouteConstants.ImportfromUrl)]
        
        public IActionResult ImportFileURL([FromBody] FileUrlInfo param)
        {
            try
            {
                using (WebClient client = new WebClient())
                {
                    byte[] data = client.DownloadData(param.fileUrl); MemoryStream stream = new MemoryStream(data);
                    string type = param.Content;
                    var document = Syncfusion.EJ2.DocumentEditor.WordDocument.Load(stream, GetFormatType(type.ToLower()));
                    string json = JsonConvert.SerializeObject(document);
                    document.Dispose();
                    stream.Dispose();
                    return Ok(json);
                }
            }
            catch (Exception)
            {
                return BadRequest("");
            }
        }
        internal static Syncfusion.EJ2.DocumentEditor.FormatType GetFormatType(string fileName)
        {
            int index = fileName.LastIndexOf('.');
            string format = index > -1 && index < fileName.Length - 1 ? fileName.Substring(index + 1) : ""; if (string.IsNullOrEmpty(format))
                throw new NotSupportedException("EJ2 Document editor does not support this file format.");
            switch (format.ToLower())
            {
                case "dotx":
                case "docx":
                case "docm":
                case "dotm":
                    return Syncfusion.EJ2.DocumentEditor.FormatType.Docx;
                case "dot":
                case "doc":
                    return Syncfusion.EJ2.DocumentEditor.FormatType.Doc;
                case "rtf":
                    return Syncfusion.EJ2.DocumentEditor.FormatType.Rtf;
                case "txt":
                    return Syncfusion.EJ2.DocumentEditor.FormatType.Txt;
                case "xml":
                    return Syncfusion.EJ2.DocumentEditor.FormatType.WordML;
                case "html":
                    return Syncfusion.EJ2.DocumentEditor.FormatType.Html;
                default:
                    throw new NotSupportedException("EJ2 Document editor does not support this file format.");
            }
        }

        [AcceptVerbs("Post")]
        [HttpPost]
        [Route("ExportPdf")]
        public FileStreamResult ExportPdf([FromBody] SaveFileParameter data)
        {
            byte[] doc1 = data.Content;
            Stream stream = new MemoryStream(doc1);
            stream.Position = 0;
            string json;

            StreamReader reader = new StreamReader(stream);
            json = reader.ReadToEnd();
            
            // Converts the sfdt to stream
            Stream document = EJ2DocumentEditor.WordDocument.Save(json, EJ2DocumentEditor.FormatType.Docx);
            Syncfusion.DocIO.DLS.WordDocument doc = new Syncfusion.DocIO.DLS.WordDocument(document, Syncfusion.DocIO.FormatType.Docx);
            //Instantiation of DocIORenderer for Word to PDF conversion 
            DocIORenderer render = new DocIORenderer();
            //Converts Word document into PDF document 
            PdfDocument pdfDocument = render.ConvertToPDF(doc);
            //string pdfjson = Newtonsoft.Json.JsonConvert.SerializeObject(pdfDocument);
            Stream pdfstream = new MemoryStream();
            //Saves the PDF file
            pdfDocument.Save(pdfstream);
            pdfstream.Position = 0;
            //stream.CopyTo(pdfstream);
            StreamReader pdfreader = new StreamReader(pdfstream);
            string pdfjson = pdfreader.ReadToEnd();
            byte[] mainBuffer = Encoding.ASCII.GetBytes(pdfjson);
            byte[] sfdtBytes = Convert.FromBase64String(pdfjson);
            reader.Dispose();
            pdfDocument.Close();
            document.Close();
            
            return new FileStreamResult(pdfstream, "application/pdf")
            {
                FileDownloadName = data.FileName
            };
        }
        public class SaveFileParameter
        {
            public byte[] Content { get; set; }
            public string FileName { get; set; }
        }

        public class FileUrlInfo
        {
            public string fileUrl { get; set; }
            public string Content { get; set; }
        }
    }
}
