using MongoDB.Bson;
using PDFHTMLDesignerCommon.Constants;
using PDFHTMLDesignerHelpers;
using PDFHTMLDesignerHelpers.Data;
using PDFHTMLDesignerModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PDFHTMLDesignerRepo.PDFDataSet;
using PDFHTMLDesignerModels.DocumentOutputModel;
using PDFHTMLDesignerModels.SFDTParameterModel;
using PDFHTMLDesignerModels.HTMLDocumentEditorModel;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using Newtonsoft.Json.Linq;
using System.Net.Http.Headers;
using System.Net.Http;
using Microsoft.Extensions.Configuration;
using System.Configuration;
using Newtonsoft.Json;
using System.Xml.Linq;
using System.Reflection;
using PDFHTMLDesignerModels.DocumentModel.file;
using Syncfusion.DocIO.DLS;
using System.Globalization;
using Azure;
using RestSharp;
using System.IO;
using Syncfusion.DocIO;
using Syncfusion.Pdf.Barcode;
using System.Reflection.Metadata;
using static SkiaSharp.HarfBuzz.SKShaper;
using System.Collections;
using System.Data.Common;
using SharpCompress.Compressors.Xz;
using System.Text.RegularExpressions;

namespace PDFHTMLDesignerServices.DocumentEditor
{
    public class PDFMenuDataSetService : IPDFMenuDataSetService
    {
        private readonly IPDFMenuDataSetRepository _pdfMenuDataSetRepository;
        private readonly IHTMLDataSetService _hTMLDataSetService;

        IConfiguration _iconfiguration;
        private int currentRunningForm = 0;
        private bool validateMongoQueryError = false;
        private bool isAllMongoQueriesValid = true;
        private List<object> replacebleTemplateParameters = new List<object>();
        private List<string> finalTemplateToDownload = new List<string>();
        private List<WebHtmlTemplateOutputModel> finalWebTemplateToDownload = new List<WebHtmlTemplateOutputModel>();
        private List<TemplateTagStylesModel> templateTagStyles = null;


        public PDFMenuDataSetService(IConfiguration iConfiguration, IPDFMenuDataSetRepository iPDFMenuDataSetRepository, IHTMLDataSetService iHTMLDataSetService)
        {
            _pdfMenuDataSetRepository = iPDFMenuDataSetRepository;
            _hTMLDataSetService = iHTMLDataSetService;
            _iconfiguration = iConfiguration;

        }

        public async Task<List<PDFDesignerDatasetOutputModel>> GetAllPDFMenuDataSet(string templateId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllPDFMenuDataSet", "PDFMenuDataSetService"));
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllPDFMenuDataSet", "PDFMenuDataSetService"));


                using (var client = new HttpClient())
                {


                    client.BaseAddress = new Uri(_iconfiguration["MongoApiBaseUrl"] + "DataService/PdfDesignerApi/GetAllPDFMenuDataSet?TemplateId=" + templateId);
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.Authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        return JsonConvert.DeserializeObject<List<PDFDesignerDatasetOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                    }
                    else
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = PDFHTMLDesignerModels.MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });
                        return null;
                    }
                }

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllPDFMenuDataSet", "PDFMenuDataSetService", exception.Message), exception);
                return null;
            }
        }
        
        public async Task<List<PDFDesignerDatasetOutputModel>> GetAllPDFMenuDataSetUnAuth(string templateId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllPDFMenuDataSetUnAuth", "PDFMenuDataSetService"));
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllPDFMenuDataSetUnAuth", "PDFMenuDataSetService"));


                using (var client = new HttpClient())
                {


                    client.BaseAddress = new Uri(_iconfiguration["MongoApiBaseUrl"] + "DataService/PdfDesignerApi/GetAllPDFMenuDataSetUnAuth?TemplateId=" + templateId);
                    //client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.Authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        return JsonConvert.DeserializeObject<List<PDFDesignerDatasetOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                    }
                    else
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = PDFHTMLDesignerModels.MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });
                        return null;
                    }
                }

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllPDFMenuDataSetUnAuth", "PDFMenuDataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<List<string>> GenerateCompleteTemplate(Guid? genericFormSubmittedId, List<PDFDesignerDatasetOutputModel> dataSources, List<object> selectedFormData, string templateString, List<TemplateTagStylesModel> tmpltTagStyles, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GenerateCompleteTemplate", "PDFMenuDataSetService"));
            try
            {
                isAllMongoQueriesValid = true;
                currentRunningForm = 0;
                templateTagStyles = tmpltTagStyles;
                if (dataSources != null && dataSources.Count > 0 && dataSources[0] != null && dataSources[0].MongoParamsType != null && dataSources.Count > 0)
                {

                    foreach (var formData in selectedFormData)
                    {
                        var counter = 0;
                        currentRunningForm = currentRunningForm + 1;
                        replacebleTemplateParameters = new List<object>();

                        foreach (var datasource in dataSources)
                        {
                            await ReplaceMongoParametersAsync(genericFormSubmittedId, selectedFormData, formData, templateString, datasource, dataSources.Count, counter, loggedInContext, validationMessages);

                        }
                    }
                    return finalTemplateToDownload;
                }
                else
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = PDFHTMLDesignerModels.MessageTypeEnum.Error,
                        ValidationMessaage = "No data sources or mongo parameters exists in this template "
                    });
                    return null;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GenerateCompleteTemplate", "PDFMenuDataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task ReplaceMongoParametersAsync(Guid? genericFormSubmittedId, List<object> selectedFormData, object formData, string templateString, PDFDesignerDatasetOutputModel dataSource, int datasourcesLength, int counter, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReplaceMongoParameters", "PDFMenuDataSetService"));
            try
            {
                var mongoQueryInputModel = new List<MongoQueryInputModel>();
                var mongoInputModel = new MongoQueryInputModel();
                mongoInputModel.MongoQuery = dataSource.MongoQuery;
                mongoInputModel.DataSourceParamValues = new List<DataSourceDummyParamValues>();
                mongoInputModel.MongoCollectionName = null;
                counter = counter + 1;

                if (dataSource.MongoDummyParams != null)
                {
                    string mongoParamValue = null;

                    if (formData != null)
                    {
                        // Convert the deserialized object to JObject
                        JObject formDataJsonObject = (JObject)formData;
                        mongoInputModel.DataSourceParamValues = new List<DataSourceDummyParamValues>();

                        foreach (var dummyValue in dataSource.MongoDummyParams)
                        {
                            // Retrieve the value using the key
                            mongoParamValue = (string)formDataJsonObject[dummyValue.Name];
                            if (mongoParamValue == null)
                            { 
                                if (genericFormSubmittedId != null && dummyValue.Name == "genericFormSubmittedId")
                                {
                                    mongoInputModel.DataSourceParamValues.Add(new DataSourceDummyParamValues { Name = dummyValue.Name, Value = genericFormSubmittedId.ToString() });
                                }
                                else
                                {
                                    validationMessages.Add(new ValidationMessage
                                    {
                                        ValidationMessageType = PDFHTMLDesignerModels.MessageTypeEnum.Error,
                                        ValidationMessaage = "Can not find mongo parameter in the given form path"
                                    });
                                }
                            }
                            else
                            {
                                mongoInputModel.DataSourceParamValues.Add(new DataSourceDummyParamValues { Name = dummyValue.Name, Value = mongoParamValue });
                            }
                        }

                        var validresult = await ValidateAndRunMongoQueryAsync(mongoQueryInputModel, mongoInputModel, datasourcesLength, counter, dataSource.DataSource, formData, templateString, selectedFormData, loggedInContext, validationMessages);

                    }
                    else
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = PDFHTMLDesignerModels.MessageTypeEnum.Error,
                            ValidationMessaage = "No Form data provided"
                        });
                    }
                }
                else
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = PDFHTMLDesignerModels.MessageTypeEnum.Error,
                        ValidationMessaage = "No mongo parameters found in datasource to replace"
                    });
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReplaceMongoParameters", "PDFMenuDataSetService", exception.Message), exception);
            }
        }

        public async Task<bool> ValidateAndRunMongoQueryAsync(List<MongoQueryInputModel> mongoQueryInputModel, MongoQueryInputModel mongoInputModel, int datasourcesLength, int counter, string dataSourceName, object formData, string templateString, List<object> selectedFormData, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidateAndRunMongoQuery", "PDFMenuDataSetService"));
            try
            {
                if (!this.validateMongoQueryError)
                {
                    mongoQueryInputModel.Add(mongoInputModel);

                    var result = await _hTMLDataSetService.ValidateAndRunMongoQuery(mongoQueryInputModel, loggedInContext, validationMessages);

                    if (result != null && result.Count > 0)
                    {
                        replacebleTemplateParameters.Add(result[0]);

                        if (datasourcesLength == counter && replacebleTemplateParameters.Count > 0 && isAllMongoQueriesValid && replacebleTemplateParameters != null)
                        {
                            await ReplaceParametersInPdfTemplate(dataSourceName, templateString, loggedInContext, validationMessages);
                            return true;
                        }
                        else
                        {
                            validationMessages.Add(new ValidationMessage
                            {
                                ValidationMessageType = PDFHTMLDesignerModels.MessageTypeEnum.Error,
                                ValidationMessaage = "Mongo Query is Invalid"
                            });
                            return false;
                        }
                    }
                    else
                    {
                        isAllMongoQueriesValid = false;
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = PDFHTMLDesignerModels.MessageTypeEnum.Error,
                            ValidationMessaage = "Mongo Query is Invalid"
                        });
                        return false;
                    }
                }
                else
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = PDFHTMLDesignerModels.MessageTypeEnum.Error,
                        ValidationMessaage = "Error in mongo query"
                    });
                    return false;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ValidateAndRunMongoQuery", "PDFMenuDataSetService", exception.Message), exception);
                return false;
            }
        }


        private async Task<bool> ReplaceParametersInPdfTemplate(string dataSourceName, string templateString, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReplaceParametersInPdfTemplate", "PDFMenuDataSetService"));

            HtmlToSfdtConversionModel inputModel = new HtmlToSfdtConversionModel();
            try
            {
                foreach (var replacebleTemplatePar in replacebleTemplateParameters)
                {
                    // Convert the deserialized object to JObject
                    JObject replaceParameters = (JObject)replacebleTemplatePar;

                    if (replaceParameters != null)
                    {
                        //inputModel.HtmlFile = await ReplaceParamsInTemplate(replaceParameters, dataSourceName, templateString, loggedInContext, validationMessages);

                        Stream streamDocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(templateString, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                        WordDocument document = new WordDocument(streamDocument, FormatType.Automatic);
                        foreach (var prop in replaceParameters)
                        {
                            if (prop.Key != "_id")
                            {
                                var propValue = prop.Value;

                                if (propValue != null && propValue.ToString() != "null")
                                {
                                    if (propValue.Type == JTokenType.Object)
                                    {
                                        var tableHeaders = propValue["tableHeaders"];
                                        var tableBody = propValue["tableBody"];

                                        if (tableHeaders != null && tableBody != null)
                                        {
                                            DynamicTableModel dynamicTable = propValue.ToObject<DynamicTableModel>();
                                            string tempplateWithDynamicTable = _hTMLDataSetService.DynamicTableCreationInDocx("#" + dataSourceName + "." + prop.Key, dynamicTable, templateTagStyles, document, validationMessages);
                                            if (tempplateWithDynamicTable != null)
                                            {
                                                templateString = tempplateWithDynamicTable;
                                            }
                                            streamDocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(templateString, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                                            document = new WordDocument(streamDocument, FormatType.Automatic);

                                        }
                                    }

                                    else if (prop.Value.ToString().Contains("https://nxusworldstorage.blob.core"))
                                    {
                                        //document = ReplaceImages( prop.Key, propValue.ToString(), templateWithDataSources.Template.TemplateTagStyles, document);

                                        TextSelection textSelections = document.Find("#" + prop.Key, true, true);

                                        //Replaces the image placeholder text with desired image
                                        WParagraph paragraph = new WParagraph(document);

                                        var imageStream = await ConvertImageUrlToStreamAsync(prop.Value.ToString());
                                        WPicture picture = paragraph.AppendPicture(imageStream) as WPicture;

                                        TemplateTagStylesModel dynamicStyles = templateTagStyles.FirstOrDefault(tagStyle => tagStyle.TagName == "#" + prop.Key);
                                        if (dynamicStyles != null)
                                        {
                                            dynamic dynamicImageStyle = JsonConvert.DeserializeObject(dynamicStyles.Style);

                                            // Accessing width and height properties
                                            string width = dynamicImageStyle.width;
                                            string height = dynamicImageStyle.height;

                                            // Converting width and height to integers if needed
                                            int widthInt = int.Parse(width);
                                            int heightInt = int.Parse(height);

                                            picture.Height = ConvertPixelToPoints(heightInt);
                                            picture.Width = ConvertPixelToPoints(widthInt);
                                        }
                                        TextSelection newSelection = new TextSelection(paragraph, 0, 1);
                                        TextBodyPart bodyPart = new TextBodyPart(document);
                                        bodyPart.BodyItems.Add(paragraph);
                                        document.Replace(textSelections.SelectedText, bodyPart, true, true);

                                    }
                                    else
                                    {
                                        document.Replace("#" + dataSourceName + "." + prop.Key, propValue.ToString(), true, true);
                                    }
                                }
                            }
                        }

                        //Saves and closes the document
                        FileStream outputStream = new FileStream("Sample.docx", FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite);
                        document.Save(outputStream, FormatType.Docx);
                        Syncfusion.EJ2.DocumentEditor.WordDocument finaldocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Load(outputStream, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                        finaldocument.OptimizeSfdt = false;
                        templateString = Newtonsoft.Json.JsonConvert.SerializeObject(finaldocument);
                        document.Dispose();
                        document.Close();
                    }
                }
                return true;
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GenerateCompleteTemplate", "PDFMenuDataSetService", exception.Message), exception);
                return false;
            }
            finally
            {
                if (templateString != null)
                {
                    finalTemplateToDownload.Add(templateString);
                }
            }
        }

        private async Task<string> ReplaceParamsInTemplate(JObject parent, string dataSourceName, string sfdtTemplateString, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReplaceParamsInTemplate", "PDFMenuDataSetService"));
            try
            {
                Stream streamDocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(sfdtTemplateString, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                WordDocument document = new WordDocument(streamDocument, FormatType.Automatic);
                foreach (var prop in parent)
                {
                    if (prop.Key != "_id")
                    {
                        var propValue = prop.Value;

                        if (propValue != null && propValue.ToString() != "null")
                        {
                            if (propValue.Type == JTokenType.Object)
                            {
                                var tableHeaders = propValue["tableHeaders"];
                                var tableBody = propValue["tableBody"];

                                if (tableHeaders == null && tableBody == null)
                                {
                                    //templateString = await ReplaceParamsInTemplate((JObject)propValue, dataSourceName, templateString , loggedInContext , validationMessages);
                                }
                                else
                                {
                                    DynamicTableModel dynamicTable = propValue.ToObject<DynamicTableModel>();
                                    //templateString = await DynamicTableFormation("#" + dataSourceName + "." + prop.Key, dynamicTable, templateString, loggedInContext , validationMessages);
                                    string tempplateWithDynamicTable = _hTMLDataSetService.DynamicTableCreationInDocx("#" + dataSourceName + "." + prop.Key, dynamicTable, templateTagStyles, document, validationMessages);
                                    if (tempplateWithDynamicTable != null)
                                    {
                                        sfdtTemplateString = tempplateWithDynamicTable;
                                    }
                                    streamDocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(sfdtTemplateString, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                                    document = new WordDocument(streamDocument, FormatType.Automatic);

                                }
                            }
                            else
                            {
                                //templateString = templateString.Replace("#" + dataSourceName + "." + prop.Key, propValue.ToString());
                                document.Replace("#" + dataSourceName + "." + prop.Key, propValue.ToString(), true, true);
                            }
                        }
                        else
                        {
                            //templateString = templateString.Replace("#" + dataSourceName + "." + prop.Key, propValue.ToString());
                            document.Replace("#" + dataSourceName + "." + prop.Key, propValue.ToString(), true, true);

                        }
                    }
                }

                //Saves and closes the document
                FileStream outputStream = new FileStream("Sample.docx", FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite);
                document.Save(outputStream, FormatType.Docx);
                Syncfusion.EJ2.DocumentEditor.WordDocument finaldocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Load(outputStream, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                finaldocument.OptimizeSfdt = false;
                sfdtTemplateString = Newtonsoft.Json.JsonConvert.SerializeObject(finaldocument);
                document.Dispose();
                document.Close();

                return sfdtTemplateString;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReplaceParamsInTemplate", "PDFMenuDataSetService", exception.Message), exception);
                return null;
            }
        }

        private async Task<string> DynamicTableFormation(string paramName, DynamicTableModel dynamicTable, string templateString, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DynamicTableFormation", "PDFMenuDataSetService"));

            try
            {
                //dynamic table creation in html 
                var tableHtml = "";
                if (dynamicTable != null)
                {
                    tableHtml = "<div><table cellspacing=\"0\" style=\"width: auto; border-collapse: collapse; \">";
                    if (dynamicTable.tableHeaders != null)
                    {
                        tableHtml += "<tr style=\"height: 2px\">";
                        foreach (var headerName in dynamicTable.tableHeaders)
                        {
                            tableHtml += $"<td style=\"vertical-align:top;border-top-style:solid;border-top-color:#000000;border-top-width:1pt;border-left-style:solid;border-left-color:#000000;border-left-width:1pt;border-right-style:solid;border-right-color:#000000;border-right-width:1pt;border-bottom-style:solid;border-bottom-color:#000000;border-bottom-width:1pt;padding-left:5.4pt;padding-right:5.4pt;padding-top:0pt;padding-bottom:0pt;width:150.43333px;\"><p class=\"Normal__Web_\" style=\"page-break-after:avoid;margin-top:0pt;margin-bottom:0pt;margin-left:0pt;text-indent:0pt;text-decoration: none\"><span lang=\"en-US\" style=\"color:#000000;font-family:Calibri;font-size:12pt;text-transform:none;font-weight:bold;font-style:normal;font-variant:normal;text-decoration: none;line-height:150%;\">{headerName}</span></p></td>";
                        }
                        tableHtml += "</tr>";
                    }
                    if (dynamicTable.tableBody != null && dynamicTable.tableBody.Count > 0)
                    {
                        foreach (JObject rowData in dynamicTable.tableBody)
                        {
                            tableHtml += "<tr style=\"height: 2px\">";
                            foreach (JProperty prop in rowData.Properties())
                            {
                                var propValue = prop.Value.ToString();
                                tableHtml += $"<td style=\"vertical-align:top;border-top-style:solid;border-top-color:#000000;border-top-width:1pt;border-left-style:solid;border-left-color:#000000;border-left-width:1pt;border-right-style:solid;border-right-color:#000000;border-right-width:1pt;border-bottom-style:solid;border-bottom-color:#000000;border-bottom-width:1pt;padding-left:5.4pt;padding-right:5.4pt;padding-top:0pt;padding-bottom:0pt;width:150.43333px;\"><p class=\"Normal__Web_\" style=\"page-break-after:avoid;margin-top:0pt;margin-bottom:0pt;margin-left:0pt;text-indent:0pt;text-decoration: none\"><span lang=\"en-US\" style=\"color:#000000;font-family:Calibri;font-size:12pt;text-transform:none;font-weight:bold;font-style:normal;font-variant:normal;text-decoration: none;line-height:150%;\">" +
                                    $"{propValue}</span></p></td>";
                            }
                            tableHtml += "</tr>";
                        }
                        tableHtml += "</table></div>";
                    }
                }

                templateString = templateString.Replace(paramName, tableHtml);


                return templateString;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DynamicTableFormation", "PDFMenuDataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<List<string>> StoreDownloadedTemplates(List<GenerateCompleteTemplatesOutputModel> downloadedTemplates, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "StoreDownloadedTemplates", "PDFMenuDataSetService"));
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SaveDataSource", "HTMLDataSetService"));


                using (var client = new HttpClient())
                {

                    client.BaseAddress = new Uri(_iconfiguration["MongoApiBaseUrl"] + "DataService/PdfDesignerApi/StoreDownloadedTemplates");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.Authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(downloadedTemplates), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var apiResponseMessages = (object)data["apiResponseMessages"];
                        var apiMessages = JsonConvert.DeserializeObject<List<PDFHTMLDesignerModels.SFDTParameterModel.ApiResponseMessage>>(JsonConvert.SerializeObject(apiResponseMessages));
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        if (apiMessages.Count > 0)
                        {
                            validationMessages.Add(new ValidationMessage
                            {
                                ValidationMessageType = PDFHTMLDesignerModels.MessageTypeEnum.Error,
                                ValidationMessaage = apiMessages[0].Message
                            });

                        }

                        return JsonConvert.DeserializeObject<List<string>>(JsonConvert.SerializeObject(dataSetResponse));
                    }
                    else
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = PDFHTMLDesignerModels.MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });
                        return null;
                    }
                }

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "StoreDownloadedTemplates", "PDFMenuDataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<List<WebHtmlTemplateOutputModel>> GenerateCompleteWebTemplate(TemplateWithDataSourcesOutputModel templateWithDataSources, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GenerateCompleteTemplate", "PDFMenuDataSetService"));
            try
            {
                if (templateWithDataSources.DataSources != null && templateWithDataSources.DataSources.Count > 0)
                {
                    var templateString = templateWithDataSources.Template.SfdtJson;
                    ReplaceWebTemplateOutputModel replaceWebTemplateOutput = new ReplaceWebTemplateOutputModel();
                    List<MongoQueryInputModel> mongoQueryInputModel = new List<MongoQueryInputModel>();

                    //Loop through the datasources that is mongo queries of the template
                    foreach (var datasource in templateWithDataSources.DataSources)
                    {
                        MongoQueryInputModel mongoInputModel = new MongoQueryInputModel();

                        //Replace the params in the mongo query 
                        if (templateWithDataSources.GenericFormSubmittedId != null && datasource != null && datasource.MongoDummyParams.Count>0 
                            && datasource.MongoDummyParams.Any(obj => obj.Name == "GenericFormSubmittedId"))
                        {
                            List<DataSourceDummyParamValues> DataSourceParamValues = new List<DataSourceDummyParamValues>
                            {
                                new DataSourceDummyParamValues { Name = "GenericFormSubmittedId", Value = templateWithDataSources.GenericFormSubmittedId.ToString() }
                            };
                            mongoInputModel = new MongoQueryInputModel { MongoQuery = datasource.MongoQuery, DataSorceParamsType = null, DataSourceParamValues = DataSourceParamValues, MongoCollectionName = null };
                        }
                        else
                        {
                            mongoInputModel = new MongoQueryInputModel { MongoQuery = datasource.MongoQuery, DataSorceParamsType = null, DataSourceParamValues = null, MongoCollectionName = null };
                        }
                        mongoQueryInputModel.Add(mongoInputModel);
                    }

                    //validate the mongo queries of the template and get the result data
                    List<dynamic> mongo_query_results = await _hTMLDataSetService.ValidateAndRunMongoQuery(mongoQueryInputModel, loggedInContext, validationMessages);

                    if (mongo_query_results != null && mongo_query_results.Count > 0)
                    {
                        foreach (var result in mongo_query_results)
                        {
                            replacebleTemplateParameters = new List<object>();
                            replacebleTemplateParameters.Add(result);

                            if (replacebleTemplateParameters.Count > 0 && isAllMongoQueriesValid && replacebleTemplateParameters != null)
                            {
                                //Replace the mongo queries result values in web template
                                replaceWebTemplateOutput = await ReplaceParametersInWebTemplate(templateWithDataSources, templateString, validationMessages);
                                if (replaceWebTemplateOutput != null)
                                {
                                    var genericFormSubId = result.GenericFormSubmittedId;
                                    finalWebTemplateToDownload.Add(new WebHtmlTemplateOutputModel { HtmlString = replaceWebTemplateOutput.HtmlString, GenericFormSubmittedId = genericFormSubId });                                   
                                }
                            }
                        }
                        return finalWebTemplateToDownload;
                    }
                    else
                    {
                        isAllMongoQueriesValid = false;
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = PDFHTMLDesignerModels.MessageTypeEnum.Error,
                            ValidationMessaage = "Mongo Query is Invalid"
                        });
                        return null;
                    }
                    
                }
                else
                {
                    Stream streamDocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(templateWithDataSources.Template.SfdtJson, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                    Syncfusion.DocIO.DLS.WordDocument document = new Syncfusion.DocIO.DLS.WordDocument(streamDocument, Syncfusion.DocIO.FormatType.Automatic);
                    // Saves and closes the document as HTML
                    FileStream HtmlOutputStream = new FileStream("Sample.html", FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite);
                    document.Save(HtmlOutputStream, Syncfusion.DocIO.FormatType.Html); // Save as HTML format
                    HtmlOutputStream.Close();

                    // Read the HTML content from the saved file
                    string htmlString = File.ReadAllText("Sample.html");
                    document.Dispose();
                    document.Close();
                    return new List<WebHtmlTemplateOutputModel> { new WebHtmlTemplateOutputModel { HtmlString = htmlString, GenericFormSubmittedId = null } };

                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GenerateCompleteTemplate", "PDFMenuDataSetService", exception.Message), exception);
                return null;
            }
        }

        private async Task<ReplaceWebTemplateOutputModel> ReplaceParametersInWebTemplate(TemplateWithDataSourcesOutputModel templateWithDataSources, string templateSting, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReplaceParametersInPdfTemplate", "PDFMenuDataSetService"));

            try
            {
                ReplaceWebTemplateOutputModel replaceWebTemplateOutput = new ReplaceWebTemplateOutputModel();
                List<JObject> allReplaceParameters = new List<JObject>();
                foreach (var replacebleTemplatePar in replacebleTemplateParameters)
                {
                    // Convert the deserialized object to JObject
                    JObject replaceParameters = (JObject)replacebleTemplatePar;
                    allReplaceParameters.Add(replaceParameters);
                }
                if (allReplaceParameters != null)
                {
                    //replaceWebTemplateOutput = await ReplaceParamsInTemplateWeb(allReplaceParameters, templateWithDataSources, templateSting, validationMessages);

                    Stream streamDocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(templateSting, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                    Syncfusion.DocIO.DLS.WordDocument document = new Syncfusion.DocIO.DLS.WordDocument(streamDocument, Syncfusion.DocIO.FormatType.Automatic);
                    int currentDataSource = 0;
                    foreach (var parent in allReplaceParameters)
                    {
                        foreach (var prop in parent)
                        {
                            if (prop.Key != "_id")
                            {
                                var propValue = prop.Value;

                                if (propValue != null && propValue.ToString() != "null")
                                {
                                    if (propValue.Type == JTokenType.Object)
                                    {
                                        var tableHeaders = propValue["tableHeaders"];
                                        var tableBody = propValue["tableBody"];

                                        if (tableHeaders != null && tableBody != null)
                                        {
                                            DynamicTableModel dynamicTable = propValue.ToObject<DynamicTableModel>();
                                            string tempplateWithDynamicTable = _hTMLDataSetService.DynamicTableCreationInDocx("#" + templateWithDataSources.DataSources[currentDataSource].DataSource + "." + prop.Key, dynamicTable, templateWithDataSources.Template.TemplateTagStyles, document, validationMessages);
                                            if (tempplateWithDynamicTable != null)
                                            {
                                                templateSting = tempplateWithDynamicTable;
                                            }
                                            streamDocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(templateSting, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                                            document = new Syncfusion.DocIO.DLS.WordDocument(streamDocument, Syncfusion.DocIO.FormatType.Automatic);

                                        }
                                    }
                                    else if(prop.Value.ToString().Contains("https://nxusworldstorage.blob.core"))
                                    {
                                            //document = ReplaceImages( prop.Key, propValue.ToString(), templateWithDataSources.Template.TemplateTagStyles, document);

                                            TextSelection textSelections = document.Find("#" + prop.Key, true, true);

                                            //Replaces the image placeholder text with desired image
                                            WParagraph paragraph = new WParagraph(document);

                                            var imageStream = await ConvertImageUrlToStreamAsync(prop.Value.ToString());
                                            WPicture picture = paragraph.AppendPicture(imageStream) as WPicture;

                                            TemplateTagStylesModel dynamicStyles = templateWithDataSources.Template.TemplateTagStyles.FirstOrDefault(tagStyle => tagStyle.TagName == "#" + prop.Key);
                                            if (dynamicStyles != null)
                                            {
                                                dynamic dynamicImageStyle = JsonConvert.DeserializeObject(dynamicStyles.Style);

                                                // Accessing width and height properties
                                                string width = dynamicImageStyle.width;
                                                string height = dynamicImageStyle.height;

                                                // Converting width and height to integers if needed
                                                int widthInt = int.Parse(width);
                                                int heightInt = int.Parse(height);

                                                picture.Height = ConvertPixelToPoints(heightInt);
                                                picture.Width = ConvertPixelToPoints(widthInt);
                                            }
                                            TextSelection newSelection = new TextSelection(paragraph, 0, 1);
                                            TextBodyPart bodyPart = new TextBodyPart(document);
                                            bodyPart.BodyItems.Add(paragraph);
                                            document.Replace(textSelections.SelectedText, bodyPart, true, true);
                                        
                                    }
                                    else
                                    {
                                        document.Replace("#" + templateWithDataSources.DataSources[currentDataSource].DataSource + "." + prop.Key, propValue.ToString(), true, true);
                                    }
                                }
                            }
                        }
                        currentDataSource++;
                    }

                    //Saves and closes the document
                    FileStream sfdtOutputStream = new FileStream("Sample.docx", FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite);
                    document.Save(sfdtOutputStream, Syncfusion.DocIO.FormatType.Docx);
                    Syncfusion.EJ2.DocumentEditor.WordDocument finaldocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Load(sfdtOutputStream, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                    finaldocument.OptimizeSfdt = true;
                    templateSting = Newtonsoft.Json.JsonConvert.SerializeObject(finaldocument);

                    // Saves and closes the document as HTML
                    FileStream HtmlOutputStream = new FileStream("Sample.html", FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite);
                    document.Save(HtmlOutputStream, Syncfusion.DocIO.FormatType.Html); // Save as HTML format
                    HtmlOutputStream.Close();

                    // Read the HTML content from the saved file
                    string htmlString = File.ReadAllText("Sample.html");
                    document.Dispose();
                    document.Close();
                    ReplaceWebTemplateOutputModel ReplaceWebTemplateResult = new ReplaceWebTemplateOutputModel();
                    ReplaceWebTemplateResult.SfdtString = templateSting;
                    ReplaceWebTemplateResult.HtmlString = htmlString;
                    replaceWebTemplateOutput = ReplaceWebTemplateResult;

                }
                //finalWebTemplateToDownload = replaceWebTemplateOutput.HtmlString;
                return replaceWebTemplateOutput;
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GenerateCompleteTemplate", "PDFMenuDataSetService", exception.Message), exception);
                return null;
            }
        }

        private async Task<ReplaceWebTemplateOutputModel> ReplaceParamsInTemplateWeb(List<JObject> allReplaceParameters, TemplateWithDataSourcesOutputModel templateWithDataSources, string sfdtTemplateString, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReplaceParamsInTemplate", "PDFMenuDataSetService"));
            try
            {

                Stream streamDocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(sfdtTemplateString, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                Syncfusion.DocIO.DLS.WordDocument document = new Syncfusion.DocIO.DLS.WordDocument(streamDocument, Syncfusion.DocIO.FormatType.Automatic);
                int currentDataSource = 0;
                foreach (var parent in allReplaceParameters)
                {
                    foreach (var prop in parent)
                    {
                        if (prop.Key != "_id")
                        {
                            var propValue = prop.Value;

                            if (propValue != null && propValue.ToString() != "null")
                            {
                                if (propValue.Type == JTokenType.Object)
                                {
                                    var tableHeaders = propValue["tableHeaders"];
                                    var tableBody = propValue["tableBody"];

                                    if (tableHeaders != null && tableBody != null)
                                    {
                                        DynamicTableModel dynamicTable = propValue.ToObject<DynamicTableModel>();
                                        //templateString = await DynamicTableFormation("#" + dataSourceName + "." + prop.Key, dynamicTable, templateString, loggedInContext , validationMessages);
                                        string tempplateWithDynamicTable = _hTMLDataSetService.DynamicTableCreationInDocx("#" + templateWithDataSources.DataSources[currentDataSource].DataSource + "." + prop.Key, dynamicTable, templateWithDataSources.Template.TemplateTagStyles, document, validationMessages);
                                        if(tempplateWithDynamicTable!=null)
                                        {
                                            sfdtTemplateString = tempplateWithDynamicTable;
                                        }
                                        streamDocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(sfdtTemplateString, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                                        document = new Syncfusion.DocIO.DLS.WordDocument(streamDocument, Syncfusion.DocIO.FormatType.Automatic);

                                    }
                                    else{

                                    }
                                }
                                else
                                {
                                    //templateString = templateString.Replace("#" + dataSourceName + "." + prop.Key, propValue.ToString());
                                    document.Replace("#" + templateWithDataSources.DataSources[currentDataSource].DataSource + "." + prop.Key, propValue.ToString(), true, true);
                                }
                            }
                            else
                            {
                                //templateString = templateString.Replace("#" + dataSourceName + "." + prop.Key, propValue.ToString());
                                document.Replace("#" + templateWithDataSources.DataSources[currentDataSource].DataSource + "." + prop.Key, propValue.ToString(), true, true);

                            }
                        }
                    }
                    currentDataSource++;
                }

                //Saves and closes the document
                FileStream sfdtOutputStream = new FileStream("Sample.docx", FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite);
                document.Save(sfdtOutputStream, Syncfusion.DocIO.FormatType.Docx);
                Syncfusion.EJ2.DocumentEditor.WordDocument finaldocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Load(sfdtOutputStream, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                finaldocument.OptimizeSfdt = true;
                sfdtTemplateString = Newtonsoft.Json.JsonConvert.SerializeObject(finaldocument);
               
                // Saves and closes the document as HTML
                FileStream HtmlOutputStream = new FileStream("Sample.html", FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite);
                document.Save(HtmlOutputStream, Syncfusion.DocIO.FormatType.Html); // Save as HTML format
                HtmlOutputStream.Close();

                // Read the HTML content from the saved file
                string htmlString = File.ReadAllText("Sample.html");
                document.Dispose();
                document.Close();
                ReplaceWebTemplateOutputModel ReplaceWebTemplateResult = new ReplaceWebTemplateOutputModel();
                ReplaceWebTemplateResult.SfdtString = sfdtTemplateString;
                ReplaceWebTemplateResult.HtmlString = htmlString;

                return ReplaceWebTemplateResult;

                //return htmlTemplateString;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReplaceParamsInTemplate", "PDFMenuDataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<List<WebHtmlTemplateOutputModel>> GenerateCompleteWebTemplateUnAuth(TemplateWithDataSourcesOutputModel templateWithDataSources, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GenerateCompleteTemplate", "PDFMenuDataSetService"));
            try
            {
               
                if (templateWithDataSources.DataSources != null && templateWithDataSources.DataSources.Count > 0)
                {
                    replacebleTemplateParameters = new List<object>();

                    var templateString = templateWithDataSources.Template.SfdtJson;
                    ReplaceWebTemplateOutputModel replaceWebTemplateOutput = new ReplaceWebTemplateOutputModel();
                    List<MongoQueryInputModel> mongoQueryInputModel = new List<MongoQueryInputModel>();

                    //Loop through the datasources that is mongo queries of the template
                    foreach (var datasource in templateWithDataSources.DataSources)
                    {
                        MongoQueryInputModel mongoInputModel = new MongoQueryInputModel();

                        //Replace the params in the mongo query 
                        if (templateWithDataSources.GenericFormSubmittedId != null && datasource != null && datasource.MongoDummyParams.Count > 0
                            && datasource.MongoDummyParams.Any(obj => obj.Name == "GenericFormSubmittedId"))
                        {
                            List<DataSourceDummyParamValues> DataSourceParamValues = new List<DataSourceDummyParamValues>
                            {
                                new DataSourceDummyParamValues { Name = "GenericFormSubmittedId", Value = templateWithDataSources.GenericFormSubmittedId.ToString() }
                            };
                            mongoInputModel = new MongoQueryInputModel { MongoQuery = datasource.MongoQuery, DataSorceParamsType = null, DataSourceParamValues = DataSourceParamValues, MongoCollectionName = null };
                        }
                        else
                        {
                            mongoInputModel = new MongoQueryInputModel { MongoQuery = datasource.MongoQuery, DataSorceParamsType = null, DataSourceParamValues = null, MongoCollectionName = null };
                        }
                        mongoQueryInputModel.Add(mongoInputModel);
                    }

                    List<dynamic> mongo_query_results = await _hTMLDataSetService.ValidateAndRunMongoQueryUnAuth(mongoQueryInputModel, validationMessages);

                    if (mongo_query_results != null && mongo_query_results.Count > 0)
                    {
                        foreach (var result in mongo_query_results)
                        {
                            replacebleTemplateParameters = new List<object>();
                            replacebleTemplateParameters.Add(result);

                            if (replacebleTemplateParameters.Count > 0 && isAllMongoQueriesValid && replacebleTemplateParameters != null)
                            {
                                //Replace the mongo queries result values in web template
                                replaceWebTemplateOutput = await ReplaceParametersInWebTemplate(templateWithDataSources, templateString, validationMessages);
                                if (replaceWebTemplateOutput != null)
                                {
                                    var genericFormSubId = result.GenericFormSubmittedId;
                                    finalWebTemplateToDownload.Add(new WebHtmlTemplateOutputModel { HtmlString = replaceWebTemplateOutput.HtmlString, GenericFormSubmittedId = genericFormSubId });
                                }
                            }
                        }
                        return finalWebTemplateToDownload;
                    }
                    else
                    {
                        isAllMongoQueriesValid = false;
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = PDFHTMLDesignerModels.MessageTypeEnum.Error,
                            ValidationMessaage = "Mongo Query is Invalid"
                        });
                        return null;
                    }

                }
                else
                {
                    Stream streamDocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(templateWithDataSources.Template.SfdtJson, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                    Syncfusion.DocIO.DLS.WordDocument document = new Syncfusion.DocIO.DLS.WordDocument(streamDocument, Syncfusion.DocIO.FormatType.Automatic);
                    // Saves and closes the document as HTML
                    FileStream HtmlOutputStream = new FileStream("Sample.html", FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite);
                    document.Save(HtmlOutputStream, Syncfusion.DocIO.FormatType.Html); // Save as HTML format
                    HtmlOutputStream.Close();

                    // Read the HTML content from the saved file
                    string htmlString = File.ReadAllText("Sample.html");
                    document.Dispose();
                    document.Close();
                    return new List<WebHtmlTemplateOutputModel> { new WebHtmlTemplateOutputModel { HtmlString = htmlString,GenericFormSubmittedId = null } };

                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GenerateCompleteTemplate", "PDFMenuDataSetService", exception.Message), exception);
                return null;
            }
        }

        public async void TriggerWorkFlow(Guid? genericFormSublittedId , LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "TriggerWorkFlow", "PDFMenuDataSetService"));
            try
            {
                using (var client = new HttpClient())
                {

                    client.BaseAddress = new Uri(_iconfiguration["ApiBasePath"] + "GenericForm/GenericFormApi/RunWorkFlows");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.Authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(new { GenericFormSubmittedId  = genericFormSublittedId, Action  = "Is pdf generated" }), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var apiResponseMessages = (object)data["apiResponseMessages"];
                        var apiMessages = JsonConvert.DeserializeObject<List<PDFHTMLDesignerModels.SFDTParameterModel.ApiResponseMessage>>(JsonConvert.SerializeObject(apiResponseMessages));
                        if (apiMessages.Count > 0)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "TriggerWorkFlow", "PDFMenuDataSetService", apiMessages[0].Message));
                        }
                    }
                    else
                    {
                        LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "TriggerWorkFlow", "PDFMenuDataSetService", response.ToString()));
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "TriggerWorkFlow", "PDFMenuDataSetService", response.ToString()));
                    }
                }

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "TriggerWorkFlow", "PDFMenuDataSetService", exception.Message), exception);
            }
        }

        public async Task<bool?> ReplaceImages()
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "TriggerWorkFlow", "PDFMenuDataSetService"));
            try
            {
                string sfdtTemplate = @"{""optimizeSfdt"":false,""sections"":[{""sectionFormat"":{""pageWidth"":612,""pageHeight"":792,""leftMargin"":72,""rightMargin"":72,""topMargin"":72,""bottomMargin"":72,""differentFirstPage"":false,""differentOddAndEvenPages"":false,""headerDistance"":36,""footerDistance"":36,""bidi"":false,""breakCode"":""NewPage"",""pageNumberStyle"":""Arabic"",""numberOfColumns"":1,""equalWidth"":true,""lineBetweenColumns"":false,""columns"":[]},""blocks"":[{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":0,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Center"",""beforeSpacing"":0,""afterSpacing"":0,""spaceBeforeAuto"":false,""spaceAfterAuto"":false,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""styleName"":""Normal (Web)"",""widowControl"":true,""listFormat"":{}},""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":16,""fontFamily"":""Times New Roman"",""fontColor"":""#2C33AEFF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":16,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""inlines"":[{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":16,""fontFamily"":""Times New Roman"",""fontColor"":""#2C33AEFF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":16,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":""Commodity Details""}]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":0,""afterSpacing"":0,""spaceBeforeAuto"":false,""spaceAfterAuto"":false,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""styleName"":""Normal (Web)"",""listFormat"":{}},""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""inlines"":[{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":"" ""}]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":0,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Right"",""beforeSpacing"":0,""afterSpacing"":0,""spaceBeforeAuto"":false,""spaceAfterAuto"":false,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""styleName"":""Normal (Web)"",""widowControl"":true,""listFormat"":{}},""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""inlines"":[{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""bidi"":false,""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":""#Details""}]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":0,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":0,""afterSpacing"":0,""spaceBeforeAuto"":false,""spaceAfterAuto"":false,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""styleName"":""Normal (Web)"",""listFormat"":{}},""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""inlines"":[]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":6,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":0,""afterSpacing"":0,""spaceBeforeAuto"":false,""spaceAfterAuto"":false,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""styleName"":""Normal (Web)"",""listFormat"":{}},""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""inlines"":[{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":""POD : #TD1.pod""}]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":6,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":0,""afterSpacing"":0,""spaceBeforeAuto"":false,""spaceAfterAuto"":false,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""styleName"":""Normal (Web)"",""listFormat"":{}},""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""inlines"":[{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":"" ""}]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":6,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":0,""afterSpacing"":0,""spaceBeforeAuto"":false,""spaceAfterAuto"":false,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""styleName"":""Normal (Web)"",""listFormat"":{}},""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""inlines"":[{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":""POL :#TD1.""},{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":""pol""}]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":6,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":0,""afterSpacing"":0,""spaceBeforeAuto"":false,""spaceAfterAuto"":false,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""styleName"":""Normal (Web)"",""listFormat"":{}},""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""inlines"":[{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":"" ""}]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":6,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":0,""afterSpacing"":0,""spaceBeforeAuto"":false,""spaceAfterAuto"":false,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""styleName"":""Normal (Web)"",""listFormat"":{}},""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""inlines"":[{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":""POD Date : #TD1.podDate""}]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":6,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":0,""afterSpacing"":0,""spaceBeforeAuto"":false,""spaceAfterAuto"":false,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""styleName"":""Normal (Web)"",""listFormat"":{}},""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""inlines"":[{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":"" ""}]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":6,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":0,""afterSpacing"":0,""spaceBeforeAuto"":false,""spaceAfterAuto"":false,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""styleName"":""Normal (Web)"",""listFormat"":{}},""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""inlines"":[{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":""POL Date : #TD1.polDate""}]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":6,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":0,""afterSpacing"":0,""spaceBeforeAuto"":false,""spaceAfterAuto"":false,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""styleName"":""Normal (Web)"",""listFormat"":{}},""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""inlines"":[{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":"" ""}]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":6,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":0,""afterSpacing"":0,""spaceBeforeAuto"":false,""spaceAfterAuto"":false,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""styleName"":""Normal (Web)"",""listFormat"":{}},""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""inlines"":[{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":""Commodity : #TD1.commodity""}]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":6,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":0,""afterSpacing"":0,""spaceBeforeAuto"":false,""spaceAfterAuto"":false,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""styleName"":""Normal (Web)"",""listFormat"":{}},""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""inlines"":[{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":"" ""}]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""styleName"":""Normal"",""listFormat"":{}},""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""inlines"":[{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""bidi"":false,""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":""   ""},{""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":12,""fontFamilyBidi"":""Times New Roman"",""allCaps"":false,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":""Price :#TD1.price""}]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""styleName"":""Normal"",""listFormat"":{}},""characterFormat"":{},""inlines"":[]},{""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""styleName"":""Normal"",""listFormat"":{}},""characterFormat"":{},""inlines"":[{""characterFormat"":{""fontSize"":12,""fontFamily"":""Times New Roman"",""fontColor"":""#000000FF"",""bidi"":false,""fontSizeBidi"":12,""fontFamilyAscii"":""Times New Roman"",""fontFamilyNonFarEast"":""Times New Roman"",""fontFamilyFarEast"":""Times New Roman""},""text"":""   #ReplaceImage""}]}],""headersFooters"":{}}],""characterFormat"":{""bold"":false,""italic"":false,""fontSize"":11,""fontFamily"":""Calibri"",""underline"":""None"",""strikethrough"":""None"",""baselineAlignment"":""Normal"",""highlightColor"":""NoColor"",""fontColor"":""#00000000"",""boldBidi"":false,""italicBidi"":false,""fontSizeBidi"":11,""fontFamilyBidi"":""Calibri"",""allCaps"":false,""fontFamilyAscii"":""Calibri"",""fontFamilyNonFarEast"":""Calibri"",""fontFamilyFarEast"":""Calibri""},""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":0,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":0,""afterSpacing"":0,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""bidi"":false,""keepLinesTogether"":false,""keepWithNext"":false,""widowControl"":true,""listFormat"":{}},""themeFontLanguages"":{},""defaultTabWidth"":36,""trackChanges"":false,""enforcement"":false,""hashValue"":"""",""saltValue"":"""",""formatting"":false,""protectionType"":""NoProtection"",""dontUseHTMLParagraphAutoSpacing"":false,""formFieldShading"":true,""compatibilityMode"":""Word2013"",""allowSpaceOfSameStyleInTable"":false,""styles"":[{""name"":""Normal"",""type"":""Paragraph"",""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""listFormat"":{}},""characterFormat"":{},""next"":""Normal""},{""name"":""Heading 1"",""type"":""Paragraph"",""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":0,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":12,""afterSpacing"":0,""lineSpacing"":1.0791666507720947,""lineSpacingType"":""Multiple"",""outlineLevel"":""Level1"",""listFormat"":{}},""characterFormat"":{""fontSize"":16,""fontFamily"":""Calibri Light"",""fontColor"":""#2F5496"",""fontSizeBidi"":16,""fontFamilyAscii"":""Calibri Light"",""fontFamilyNonFarEast"":""Calibri Light"",""fontFamilyFarEast"":""Calibri Light""},""basedOn"":""Normal"",""link"":""Heading 1 Char"",""next"":""Normal""},{""name"":""Heading 1 Char"",""type"":""Character"",""characterFormat"":{""fontSize"":16,""fontFamily"":""Calibri Light"",""fontColor"":""#2F5496"",""fontSizeBidi"":16,""fontFamilyAscii"":""Calibri Light"",""fontFamilyNonFarEast"":""Calibri Light"",""fontFamilyFarEast"":""Calibri Light""},""basedOn"":""Default Paragraph Font""},{""name"":""Default Paragraph Font"",""type"":""Character"",""characterFormat"":{}},{""name"":""Heading 2"",""type"":""Paragraph"",""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":0,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":2,""afterSpacing"":0,""lineSpacing"":1.0791666507720947,""lineSpacingType"":""Multiple"",""outlineLevel"":""Level2"",""listFormat"":{}},""characterFormat"":{""fontSize"":13,""fontFamily"":""Calibri Light"",""fontColor"":""#2F5496"",""fontSizeBidi"":13,""fontFamilyAscii"":""Calibri Light"",""fontFamilyNonFarEast"":""Calibri Light"",""fontFamilyFarEast"":""Calibri Light""},""basedOn"":""Normal"",""link"":""Heading 2 Char"",""next"":""Normal""},{""name"":""Heading 2 Char"",""type"":""Character"",""characterFormat"":{""fontSize"":13,""fontFamily"":""Calibri Light"",""fontColor"":""#2F5496"",""fontSizeBidi"":13,""fontFamilyAscii"":""Calibri Light"",""fontFamilyNonFarEast"":""Calibri Light"",""fontFamilyFarEast"":""Calibri Light""},""basedOn"":""Default Paragraph Font""},{""name"":""Heading 3"",""type"":""Paragraph"",""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":0,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":2,""afterSpacing"":0,""lineSpacing"":1.0791666507720947,""lineSpacingType"":""Multiple"",""outlineLevel"":""Level3"",""listFormat"":{}},""characterFormat"":{""fontSize"":12,""fontFamily"":""Calibri Light"",""fontColor"":""#1F3763"",""fontSizeBidi"":12,""fontFamilyAscii"":""Calibri Light"",""fontFamilyNonFarEast"":""Calibri Light"",""fontFamilyFarEast"":""Calibri Light""},""basedOn"":""Normal"",""link"":""Heading 3 Char"",""next"":""Normal""},{""name"":""Heading 3 Char"",""type"":""Character"",""characterFormat"":{""fontSize"":12,""fontFamily"":""Calibri Light"",""fontColor"":""#1F3763"",""fontSizeBidi"":12,""fontFamilyAscii"":""Calibri Light"",""fontFamilyNonFarEast"":""Calibri Light"",""fontFamilyFarEast"":""Calibri Light""},""basedOn"":""Default Paragraph Font""},{""name"":""Heading 4"",""type"":""Paragraph"",""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":0,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":2,""afterSpacing"":0,""lineSpacing"":1.0791666507720947,""lineSpacingType"":""Multiple"",""outlineLevel"":""Level4"",""listFormat"":{}},""characterFormat"":{""italic"":true,""fontFamily"":""Calibri Light"",""fontColor"":""#2F5496"",""italicBidi"":true,""fontFamilyAscii"":""Calibri Light"",""fontFamilyNonFarEast"":""Calibri Light"",""fontFamilyFarEast"":""Calibri Light""},""basedOn"":""Normal"",""link"":""Heading 4 Char"",""next"":""Normal""},{""name"":""Heading 4 Char"",""type"":""Character"",""characterFormat"":{""italic"":true,""fontFamily"":""Calibri Light"",""fontColor"":""#2F5496"",""italicBidi"":true,""fontFamilyAscii"":""Calibri Light"",""fontFamilyNonFarEast"":""Calibri Light"",""fontFamilyFarEast"":""Calibri Light""},""basedOn"":""Default Paragraph Font""},{""name"":""Heading 5"",""type"":""Paragraph"",""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":0,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":2,""afterSpacing"":0,""lineSpacing"":1.0791666507720947,""lineSpacingType"":""Multiple"",""outlineLevel"":""Level5"",""listFormat"":{}},""characterFormat"":{""fontFamily"":""Calibri Light"",""fontColor"":""#2F5496"",""fontFamilyAscii"":""Calibri Light"",""fontFamilyNonFarEast"":""Calibri Light"",""fontFamilyFarEast"":""Calibri Light""},""basedOn"":""Normal"",""link"":""Heading 5 Char"",""next"":""Normal""},{""name"":""Heading 5 Char"",""type"":""Character"",""characterFormat"":{""fontFamily"":""Calibri Light"",""fontColor"":""#2F5496"",""fontFamilyAscii"":""Calibri Light"",""fontFamilyNonFarEast"":""Calibri Light"",""fontFamilyFarEast"":""Calibri Light""},""basedOn"":""Default Paragraph Font""},{""name"":""Heading 6"",""type"":""Paragraph"",""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""leftIndent"":0,""rightIndent"":0,""firstLineIndent"":0,""textAlignment"":""Left"",""beforeSpacing"":2,""afterSpacing"":0,""lineSpacing"":1.0791666507720947,""lineSpacingType"":""Multiple"",""outlineLevel"":""Level6"",""listFormat"":{}},""characterFormat"":{""fontFamily"":""Calibri Light"",""fontColor"":""#1F3763"",""fontFamilyAscii"":""Calibri Light"",""fontFamilyNonFarEast"":""Calibri Light"",""fontFamilyFarEast"":""Calibri Light""},""basedOn"":""Normal"",""link"":""Heading 6 Char"",""next"":""Normal""},{""name"":""Heading 6 Char"",""type"":""Character"",""characterFormat"":{""fontFamily"":""Calibri Light"",""fontColor"":""#1F3763"",""fontFamilyAscii"":""Calibri Light"",""fontFamilyNonFarEast"":""Calibri Light"",""fontFamilyFarEast"":""Calibri Light""},""basedOn"":""Default Paragraph Font""},{""name"":""Header"",""type"":""Paragraph"",""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""afterSpacing"":0,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""listFormat"":{}},""characterFormat"":{},""basedOn"":""Normal"",""next"":""Header""},{""name"":""Footer"",""type"":""Paragraph"",""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""afterSpacing"":0,""lineSpacing"":1,""lineSpacingType"":""Multiple"",""listFormat"":{}},""characterFormat"":{},""basedOn"":""Normal"",""next"":""Footer""},{""name"":""Normal (Web)"",""type"":""Paragraph"",""paragraphFormat"":{""borders"":{""top"":{},""left"":{},""right"":{},""bottom"":{},""horizontal"":{},""vertical"":{}},""beforeSpacing"":5,""afterSpacing"":5,""spaceBeforeAuto"":true,""spaceAfterAuto"":true,""listFormat"":{}},""characterFormat"":{""fontSize"":12,""fontSizeBidi"":12},""basedOn"":""Normal"",""next"":""Normal (Web)""}],""lists"":[],""abstractLists"":[],""comments"":[],""revisions"":[],""customXml"":[],""images"":{}}";
                Stream streamDocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(sfdtTemplate, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                WordDocument document = new WordDocument(streamDocument, FormatType.Automatic);
                //Finds all the image placeholder text in the Word document
                TextSelection textSelections = document.Find("#ReplaceImage", true, true);

                //Replaces the image placeholder text with desired image
                WParagraph paragraph = new WParagraph(document);

                var imageUrl = "https://nxusworldstorage.blob.core.windows.net/81ad93d0-05c2-49d5-9c20-16779edf2ca7/hrm/eaa0ebf0-2afe-4ce6-9d74-4b0f17eade57/version-1/image1.jpg";

                var imageStream = await ConvertImageUrlToStreamAsync(imageUrl);

                WPicture picture = paragraph.AppendPicture(imageStream) as WPicture;
                picture.Height = ConvertPixelToPoints(120);
                picture.Width = ConvertPixelToPoints(240);
                TextSelection newSelection = new TextSelection(paragraph, 0, 1);
                TextBodyPart bodyPart = new TextBodyPart(document);
                bodyPart.BodyItems.Add(paragraph);
                document.Replace(textSelections.SelectedText, bodyPart, true, true);
                //Saves and closes the document
                FileStream outputStream = new FileStream("Sample.docx", FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite);
                document.Save(outputStream, FormatType.Docx);
                document.Close();
                return null;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "TriggerWorkFlow", "PDFMenuDataSetService", exception.Message), exception);
                return null;
            }
        }
        public async Task<MemoryStream> ConvertImageUrlToStreamAsync(string imageUrl)
        {
            using var httpClient = new HttpClient();

            try
            {
                var response = await httpClient.GetAsync(imageUrl);
                response.EnsureSuccessStatusCode();

                using var stream = await response.Content.ReadAsStreamAsync();
                var memoryStream = new MemoryStream();
                await stream.CopyToAsync(memoryStream);
                memoryStream.Seek(0, SeekOrigin.Begin); // Reset the stream position to the beginning
                return memoryStream;
            }
            catch (HttpRequestException ex)
            {
                // Handle any exceptions here
                Console.WriteLine($"Error converting image URL to stream: {ex.Message}");
                return null;
            }
        }
        /// Converts pixel to points
        public float ConvertPixelToPoints(int pixel)

        {

            float point = pixel * 72 / 96;

            return point;

        }

    }
}
