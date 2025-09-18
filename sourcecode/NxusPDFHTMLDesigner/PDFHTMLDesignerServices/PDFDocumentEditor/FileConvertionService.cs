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
using Azure.Storage.Blobs;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using System.Text;
using PDFHTMLDesignerModels.HTMLDocumentEditorModel;
using PDFHTMLDesignerRepo.HTMLDataSet;
using System.Collections.Generic;
using Models.DeletePDFHTMLDesigner;

namespace PDFHTMLDesignerServices.DocumentEditor
{
    public class FileConvertionService : IFileConvertionService
    {
        IConfiguration _iconfiguration;
        private readonly IHTMLDataSetRepository _htmlDataSetRepository;

        public object HtmlExportImageSavingMethod { get; private set; }

        public FileConvertionService(IConfiguration iConfiguration, IHTMLDataSetRepository iHTMLDataSetRepository)//IFileConvertionService iFileConvertionService, IFileStoreService fileStoreService, FileRepository fileRepository, StoreRepository storeRepository, IWebHostEnvironment environment, IConfiguration iConfiguration)
        {
            _iconfiguration = iConfiguration;
            _htmlDataSetRepository = iHTMLDataSetRepository;
        }

        protected IMongoDatabase GetMongoDbConnection()
        {
            MongoClient client = new MongoClient(_iconfiguration["MongoDBConnectionString"]);
            return client.GetDatabase(_iconfiguration["MongoCommunicatorDB"]);
        }
        protected IMongoCollection<T> GetMongoCollectionObject<T>(string collectionName)
        {
            IMongoDatabase imongoDb = GetMongoDbConnection();
            return imongoDb.GetCollection<T>(collectionName);
        }

        public string ConvertSFDTToHTML(string blobPath, string filetype, string filename, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateFileDataSet", "FileDatasetService"));
            WebClient client = new WebClient();
            HTMLDatasetInputModel hTMLDataset = new HTMLDatasetInputModel();
            //Download data from azure blob path as byte array  
            byte[] doc = client.DownloadData(blobPath);

            //Convert byte array to stream   
            Stream stream = new MemoryStream(doc);
            stream.Position = 0;
            string type = "";
            int index = blobPath.LastIndexOf('.');
            type = index > -1 && index < blobPath.Length - 1 ? blobPath.Substring(index + 1) : "";
            type = type.ToLower();
            string json = "", htmljson = "";

            if (type == "sfdt" && filetype == ".html")
            {
                StreamReader reader = new StreamReader(stream);
                // Read content of stream as string  
                json = reader.ReadToEnd();
                reader.Dispose();
                var unixDateTime = DateTimeOffset.Now.ToUnixTimeMilliseconds();
               
                Stream document = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(json, Syncfusion.EJ2.DocumentEditor.FormatType.Html);

                StreamReader htmlreader = new StreamReader(document);
                // Read content of stream as string  
                htmljson = htmlreader.ReadToEnd();

                document.Close();
                stream.Dispose();
                htmlreader.Dispose();
                return htmljson;
            }
            return null;
        }

       
        public string ConvertSFDTToHTMLSaveInFolder(string blobPath, string filetype, string filename)
        {
            WebClient client = new WebClient();

            //Download data from azure blob path as byte array  
            byte[] doc = client.DownloadData(blobPath);

            //Convert byte array to stream   
            Stream stream = new MemoryStream(doc);
            stream.Position = 0;
            string type = "";
            string filelocation;
            int index = blobPath.LastIndexOf('.');
            type = index > -1 && index < blobPath.Length - 1 ? blobPath.Substring(index + 1) : "";
            type = type.ToLower();
            string json = "", htmljson = "";

            if (type == "sfdt" && filetype == ".html")
            {
                StreamReader reader = new StreamReader(stream);
                // Read content of stream as string  
                json = reader.ReadToEnd();
                reader.Dispose();

                var unixDateTime = DateTimeOffset.Now.ToUnixTimeMilliseconds();
                DirectoryInfo dirInfofile = new DirectoryInfo(EditorConstants.FileDirectory + "\\" + unixDateTime + "_" + filename + ".html");

                Stream document = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(json, Syncfusion.EJ2.DocumentEditor.FormatType.Html);
                StreamReader htmlreader = new StreamReader(document);
                // Read content of stream as string  
                htmljson = htmlreader.ReadToEnd();


                FileStream file = new FileStream(dirInfofile.FullName, FileMode.OpenOrCreate, FileAccess.ReadWrite);
                filelocation = dirInfofile.FullName;
                document.CopyTo(file);

                MemoryStream ms = new MemoryStream();
                file.Close();
                FileStream fileTest = new FileStream(dirInfofile.FullName, FileMode.OpenOrCreate, FileAccess.ReadWrite);

                byte[] ImageData = new byte[fileTest.Length];

                //Read block of bytes from stream into the byte array
                fileTest.Read(ImageData, 0, System.Convert.ToInt32(fileTest.Length));

                //Close the File Stream
                file.Close();

                file.Close();
                document.Close();
                filelocation = dirInfofile.FullName;
                stream.Dispose();
                byte[] bytes = ImageData; //return the byte data
                fileTest.Close();
                htmlreader.Dispose();

                using (var imageFile = new FileStream(dirInfofile.FullName, FileMode.Create))
                {
                    imageFile.Write(ImageData);
                    imageFile.Write(ImageData, 0, ImageData.Length);
                    imageFile.Flush();
                }
                var htmlfile = ConvertHTML(dirInfofile.FullName);
                return htmljson;
            }
            return null;
        }

        public string ConvertHTML(string filePath)
        {
            WebClient client = new WebClient();

            //Download data from azure blob path as byte array  
            byte[] doc = client.DownloadData(filePath);

            //Convert byte array to stream   
            Stream stream = new MemoryStream(doc);
            stream.Position = 0;
            string type = "";
            int index = filePath.LastIndexOf('.');
            type = index > -1 && index < filePath.Length - 1 ? filePath.Substring(index + 1) : "";
            type = type.ToLower();
            string json = "";
            StreamReader reader = new StreamReader(stream);
            // Read content of stream as string  
            json = reader.ReadToEnd();
            reader.Dispose();
            return json;
        }

        public async Task UploadStream(BlobContainerClient containerClient, string localFilePath)
        {
            string fileName = Path.GetFileName(localFilePath);
            BlobClient blobClient = containerClient.GetBlobClient(fileName);

            FileStream fileStream = File.OpenRead(localFilePath);
            await blobClient.UploadAsync(fileStream, true);
            fileStream.Close();
        }

        public async Task<string> ConvertSFDTToHTMLFileAsync(string blobPath, string filetype, string filename, LoggedInContext loggedInContext)
        {
            try
            {
                byte[] buffer = null;
                byte[] mainBuffer = null;
                string htmlReader = "", htmlData = "";

                using (var client = new WebClient())
                {
                    buffer = client.DownloadData(blobPath);
                    using (Stream stream = new MemoryStream(buffer))
                    {
                        int length = (int)stream.Length;
                        StreamReader reader = new StreamReader(stream);
                        htmlReader = reader.ReadToEnd();
                        reader.Dispose();
                        var unixDateTime = DateTimeOffset.Now.ToUnixTimeMilliseconds();

                        Stream document = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(htmlReader, Syncfusion.EJ2.DocumentEditor.FormatType.Html);

                        StreamReader htmlreader = new StreamReader(document);
                        // Read content of stream as string  
                        htmlData = htmlreader.ReadToEnd();
                        mainBuffer = Encoding.ASCII.GetBytes(htmlData);
                        htmlreader.Dispose();
                    }
                }

                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(_iconfiguration["DocumentStorageApiUrl"] + "File/FileApi/UploadLocalFileToBlob");
                    client.DefaultRequestHeaders.Add("Authorization", "Bearer " + loggedInContext.Authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                    UploadFileToBlobInputModel uploadFileToBlobInputModel = new UploadFileToBlobInputModel
                    {
                        //LocalFilePath = "file:///E:/Projects/Nxus/sourcecode/NxusPDFHTMLDesigner/PDFHTMLDesigner/ConvertedFiles/1675250967855_Test123.html",
                        FileName = filename,
                        ModuleTypeId = 1,
                        ContentType = filetype,
                        Bytes = mainBuffer,
                        ParentDocumentId = new Guid("a6c23d32-6e08-4431-a0c8-d5ceb29cf21a") //TODO : Need to remove hardcoding
                    };

                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(Newtonsoft.Json.JsonConvert.SerializeObject(uploadFileToBlobInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);

                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        string blobUrl = result != null ? Newtonsoft.Json.JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString() : null;

                        return blobUrl;
                    }
                    return null;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ConvertSFDTToHTMLFile", "FileConvertionService", exception.Message), exception);
                return null;
            }
        }
    }
}