using MongoDB.Bson;
using PDFHTMLDesignerCommon.Constants;
using PDFHTMLDesignerModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PDFHTMLDesignerRepo.HTMLDataSet;
using PDFHTMLDesignerModels.HTMLDocumentEditorModel;
using System.IO;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using Models.DeletePDFHTMLDesigner;
//using Syncfusion.EJ2.DocumentEditor;
using System.Net.Http.Headers;
using System.Net.Http;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Syncfusion.DocIO.DLS;
using Syncfusion.DocIO;
using Syncfusion.Drawing;
using MongoDB.Driver;
using Syncfusion.Pdf;
using Syncfusion.DocIORenderer;
using PDFHTMLDesignerModels.SFDTParameterModel;
using PDFHTMLDesignerCommon.Utilities;
using Syncfusion.Pdf.Graphics;
using Syncfusion.Pdf.Parsing;
using HarfBuzzSharp;
using Microsoft.SqlServer.Server;

namespace PDFHTMLDesignerServices.DocumentEditor
{
    public class HTMLDataSetService : IHTMLDataSetService
    {
        IConfiguration _iconfiguration;

        private readonly IHTMLDataSetRepository _htmlDataSetRepository;

        public HTMLDataSetService(IConfiguration iConfiguration, IHTMLDataSetRepository iHTMLDataSetRepository)
        {
            _htmlDataSetRepository = iHTMLDataSetRepository;
            _iconfiguration = iConfiguration;
        }


        public async Task<HTMLDatasetOutputModel> InsertHTMLDataSet(HTMLDatasetsaveModel datasetsaveModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertHTMLDataSet", "HTMLDataSetService"));


                byte[] doc = datasetsaveModel.SFDTFile;
                Stream stream = new MemoryStream(doc);
                stream.Position = 0;
                string json, htmljson;

                StreamReader reader = new StreamReader(stream);
                json = reader.ReadToEnd();
                reader.Dispose();
                Stream document = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(json, Syncfusion.EJ2.DocumentEditor.FormatType.Html);
                StreamReader htmlreader = new StreamReader(document);
                htmljson = htmlreader.ReadToEnd();

                // Convert the list of objects to a JSON string
                string templateTagStylesJson = datasetsaveModel.TemplateTagStyles.Count > 0 ? JsonConvert.SerializeObject(datasetsaveModel.TemplateTagStyles) : null;

                var templateInputModel = new
                {
                    _id = datasetsaveModel._id,
                    FileName = datasetsaveModel.FileName,
                    TemplateType = datasetsaveModel.TemplateType,
                    HTMLFile = htmljson,
                    SfdtJson = datasetsaveModel.SfdtJson,
                    DataSources = datasetsaveModel.DataSources,
                    TemplateTagStyles = datasetsaveModel.TemplateTagStyles,
                    TemplatePermissions = datasetsaveModel.TemplatePermissions,
                    AllowAnonymous = datasetsaveModel.AllowAnonymous,
                    CreatedByUserId = loggedInContext.LoggedInUserId,
                    CreatedDateTime = DateTime.UtcNow,
                    IsArchived = false
                };

                document.Close();
                stream.Dispose();
                htmlreader.Dispose();
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertHTMLDataSet", "HTMLDatasetService"));

                using (var client = new HttpClient())
                {

                    client.BaseAddress = new Uri(_iconfiguration["MongoApiBaseUrl"] + "DataService/PdfDesignerApi/InsertHTMLDataSet");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.Authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(templateInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        return JsonConvert.DeserializeObject<HTMLDatasetOutputModel>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertHTMLDataSet", "HTMLDataSetService", exception.Message), exception);
                return null;
            }
        }


        public async Task<string> UpdateHTMLDataSetById(HTMLDatasetEditModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateHTMLDataSetById", "HTMLDataSetService"));
                byte[] doc = inputModel.SFDTFile;
                Stream stream = new MemoryStream(doc);
                stream.Position = 0;
                string json;

                StreamReader reader = new StreamReader(stream);
                json = reader.ReadToEnd();
                reader.Dispose();
                Stream document = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(json, Syncfusion.EJ2.DocumentEditor.FormatType.Html);
                StreamReader htmlreader = new StreamReader(document);
                inputModel.HtmlJson = htmlreader.ReadToEnd();
                // Convert the list of objects to a JSON string
                string templateTagStylesJson = JsonConvert.SerializeObject(inputModel.TemplateTagStyles);

                var updateTemplate = new
                {
                    _id = inputModel._id,
                    SFDTFile = inputModel.SFDTFile,
                    SfdtJson = inputModel.SfdtJson,
                    FileName = inputModel.FileName,
                    TemplateType = inputModel.TemplateType,
                    DataSources = inputModel.DataSources,
                    HtmlJson = htmlreader.ReadToEnd(),
                    TemplateTagStyles = inputModel.TemplateTagStyles,
                    TemplatePermissions = inputModel.TemplatePermissions,
                    AllowAnonymous = inputModel.AllowAnonymous

                };
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateHTMLDataSetById", "HTMLDataSetService"));

                using (var client = new HttpClient())
                {

                    client.BaseAddress = new Uri(_iconfiguration["MongoApiBaseUrl"] + "DataService/PdfDesignerApi/UpdateHTMLDataSetById");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.Authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(updateTemplate), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        return JsonConvert.DeserializeObject<string>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateHTMLDataSetById", "HTMLDataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<Guid?> RemoveHTMLDataSetById(RemoveByIdInputModel removeById, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "RemoveHTMLDataSetById", "HTMLDataSetService"));


                using (var client = new HttpClient())
                {


                    client.BaseAddress = new Uri(_iconfiguration["MongoApiBaseUrl"] + "DataService/PdfDesignerApi/RemoveHTMLDataSetById");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.Authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(removeById), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        return JsonConvert.DeserializeObject<Guid?>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "RemoveHTMLDataSetById", "HTMLDataSetService", exception.Message), exception);
                return null;
            }
        }


        public async Task<TemplateOutputModel> GetHTMLDataSetById(Guid id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SaveDataSource", "HTMLDataSetService"));


                using (var client = new HttpClient())
                {


                    client.BaseAddress = new Uri(_iconfiguration["MongoApiBaseUrl"] + "DataService/PdfDesignerApi/GetHTMLDataSetById?Id=" + id);
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.Authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;

                        var template = JsonConvert.DeserializeObject<TemplateOutputModel>(JsonConvert.SerializeObject(dataSetResponse));

                        if (template.HTMLFile != null)
                        {
                            try
                            {
                                if (template.TemplateType == "html")
                                {
                                    Syncfusion.EJ2.DocumentEditor.WordDocument document = Syncfusion.EJ2.DocumentEditor.WordDocument.LoadString(template.HTMLFile, Syncfusion.EJ2.DocumentEditor.FormatType.Html);

                                    string json = Newtonsoft.Json.JsonConvert.SerializeObject(document);
                                    document.Dispose();
                                    template.SfdtFile = json;
                                }
                                else
                                {
                                    template.SfdtFile = template.SfdtJson;
                                }
                            }
                            catch (Exception exception)
                            {
                                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHTMLDataSetById", " Coverting From Html to Sfdt", exception.Message), exception);
                            }
                        }
                        return template;

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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHTMLDataSetById", "HTMLDataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<TemplateOutputModel> GetHTMLDataSetByIdUnAuth(Guid id, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHTMLDataSetByIdUnAuth", "HTMLDataSetService"));


                using (var client = new HttpClient())
                {


                    client.BaseAddress = new Uri(_iconfiguration["MongoApiBaseUrl"] + "DataService/PdfDesignerApi/GetHTMLDataSetByIdUnAuth?Id=" + id);
                    //client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.Authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;

                        var template = JsonConvert.DeserializeObject<TemplateOutputModel>(JsonConvert.SerializeObject(dataSetResponse));

                        if (template.HTMLFile != null)
                        {
                            try
                            {
                                if (template.TemplateType == "html")
                                {
                                    Syncfusion.EJ2.DocumentEditor.WordDocument document = Syncfusion.EJ2.DocumentEditor.WordDocument.LoadString(template.HTMLFile, Syncfusion.EJ2.DocumentEditor.FormatType.Html);

                                    string json = Newtonsoft.Json.JsonConvert.SerializeObject(document);
                                    document.Dispose();
                                    template.SfdtFile = json;
                                }
                                else
                                {
                                    template.SfdtFile = template.SfdtJson;
                                }
                            }
                            catch (Exception exception)
                            {
                                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHTMLDataSetByIdUnAuth", " Coverting From Html to Sfdt", exception.Message), exception);
                            }
                        }
                        return template;

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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHTMLDataSetById", "HTMLDataSetService", exception.Message), exception);
                return null;
            }
        }


        public async Task<List<MenuDatasetInputModel>> SaveDataSource(DataSourceDetailsInputModel dataSourceDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SaveDataSource", "HTMLDataSetService"));


                using (var client = new HttpClient())
                {

                    client.BaseAddress = new Uri(_iconfiguration["MongoApiBaseUrl"] + "DataService/PdfDesignerApi/SaveDataSource");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.Authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSourceDetailsInputModel), Encoding.UTF8, "application/json");
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

                        return JsonConvert.DeserializeObject<List<MenuDatasetInputModel>>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveDataSource", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }

        public async Task<List<dynamic>> ValidateAndRunMongoQuery(List<MongoQueryInputModel> mongoQueryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ConversionFromHtmltoSfdt", "HTMLDataSetService"));


                using (var client = new HttpClient())
                {

                    client.BaseAddress = new Uri(_iconfiguration["MongoApiBaseUrl"] + "DataService/PdfDesignerApi/ValidateAndRunMongoQuery");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.Authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(mongoQueryInputModel), Encoding.UTF8, "application/json");
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

                        return JsonConvert.DeserializeObject<List<dynamic>>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ConversionFromHtmltoSfdt", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }
        public async Task<List<dynamic>> ValidateAndRunMongoQueryUnAuth(List<MongoQueryInputModel> mongoQueryInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ConversionFromHtmltoSfdt", "HTMLDataSetService"));


                using (var client = new HttpClient())
                {

                    client.BaseAddress = new Uri(_iconfiguration["MongoApiBaseUrl"] + "DataService/PdfDesignerApi/ValidateAndRunMongoQueryUnAuth");
                    //client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.Authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(mongoQueryInputModel), Encoding.UTF8, "application/json");
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

                        return JsonConvert.DeserializeObject<List<dynamic>>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ConversionFromHtmltoSfdt", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }
        public string ConversionFromHtmltoSfdt(HtmlToSfdtConversionModel HtmlFile, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ConversionFromHtmltoSfdt", "HTMLDataSetService"));
                //string htmlData = "<html><body><h1>Hello, world!</h1></body></html>";

                if (HtmlFile.HtmlFile != null)
                {
                    Syncfusion.EJ2.DocumentEditor.WordDocument document = Syncfusion.EJ2.DocumentEditor.WordDocument.LoadString(HtmlFile.HtmlFile, Syncfusion.EJ2.DocumentEditor.FormatType.Html);
                    document.OptimizeSfdt = false;
                    string json = Newtonsoft.Json.JsonConvert.SerializeObject(document);
                    document.Dispose();
                    return json;
                }
                return null;


            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ConversionFromHtmltoSfdt", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }

        public string DynamicTableCreationInDocx(string paramName, DynamicTableModel dynamicTable, List<TemplateTagStylesModel> templateTagStyles, WordDocument document, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DynamicTableCreationInDocx", "HTMLDataSetService"));

                if (document != null && dynamicTable.tableHeaders != null && dynamicTable.tableHeaders.Count > 0)
                {

                    WTable dynamictable = new WTable(document);
                    dynamictable.Title = paramName;
                    dynamictable.ResetCells(1, dynamicTable.tableHeaders.Count);
                    if (dynamicTable.tableHeaders != null)
                    {
                        for (var headerCell = 0; headerCell < dynamicTable.tableHeaders.Count; headerCell++)
                        {
                            dynamictable[0, headerCell].AddParagraph().AppendText(dynamicTable.tableHeaders[headerCell]);
                        }
                    }
                    if (dynamicTable.tableBody != null && dynamicTable.tableBody.Count > 0)
                    {

                        foreach (JObject rowData in dynamicTable.tableBody)
                        {
                            WTableRow tableRow = dynamictable.AddRow(true);
                            int index = 0;
                            foreach (JProperty prop in rowData.Properties())
                            {
                                var propValue = prop.Value.ToString();
                                tableRow.Cells[index].AddParagraph().AppendText(propValue);
                                index++;
                            }
                        }
                    }

                    //Find the placeholder text and get the text range.

                    WTextRange foundTextRange = document.Find(paramName, true, true)?.GetAsOneRange();

                    if (foundTextRange != null)
                    {

                        //Get the owner paragraph of the text range.

                        WParagraph paragraph = foundTextRange.OwnerParagraph;

                        //Get the left indent value of the paragraph.

                        float leftIndent = paragraph.ParagraphFormat.LeftIndent;

                        //Set the left indent value to the table.

                        dynamictable.TableFormat.LeftIndent = leftIndent;

                        //Replaces the table placeholder text with a new table
                        TextBodyPart bodyPart = new TextBodyPart(document);
                        bodyPart.BodyItems.Add(dynamictable);
                        document.Replace(paramName, bodyPart, true, true, true);

                        TemplateTagStylesModel dynamicTableStyles = templateTagStyles.FirstOrDefault(tagStyle => tagStyle.TagName == paramName);


                        if (dynamicTableStyles != null)
                        {
                            dynamic dynamicObject = JsonConvert.DeserializeObject(dynamicTableStyles.Style);


                            //Adds a new custom table style.
                            WTableStyle tableStyle = document.AddTableStyle("CustomStyle") as WTableStyle;

                            //Applies table border color.
                            if (dynamicObject.tableBorderColor != null)
                            {
                                var tableBorderColor = HexToRgb(dynamicObject.tableBorderColor.ToString());

                                tableStyle.TableProperties.Borders.LineWidth = 1f;
                                tableStyle.TableProperties.Borders.Horizontal.LineWidth = 1f;
                                tableStyle.TableProperties.Borders.Vertical.LineWidth = 1f;
                                tableStyle.TableProperties.Borders.Color = tableBorderColor;
                                tableStyle.TableProperties.Borders.Horizontal.Color = tableBorderColor;
                                tableStyle.TableProperties.Borders.Vertical.Color = tableBorderColor;
                            }


                            //Applies table header background color.
                            if (dynamicObject.headerBackGroundColor != null)
                            {
                                tableStyle.TableProperties.RowStripe = 1;
                                tableStyle.TableProperties.ColumnStripe = 1;
                                ConditionalFormattingStyle firstRowStyle = tableStyle.ConditionalFormattingStyles.Add(ConditionalFormattingType.FirstRow);
                                firstRowStyle.CellProperties.BackColor = HexToRgb(dynamicObject.headerBackGroundColor.ToString());
                                firstRowStyle.ParagraphFormat.HorizontalAlignment = HorizontalAlignment.Center;

                            }

                            //Applies background color for alternative rows.
                            if (dynamicObject.tableBodyAlternateRowColor != null)
                            {
                                ConditionalFormattingStyle oddRowBandingStyle = tableStyle.ConditionalFormattingStyles.Add(ConditionalFormattingType.OddRowBanding);
                                oddRowBandingStyle.CellProperties.BackColor = HexToRgb(dynamicObject.tableBodyAlternateRowColor.ToString());
                            }

                            #region Create TableHeaderFormat
                            WCharacterFormat tableHeaderFormat = new WCharacterFormat(dynamictable.Document);

                            //Applies table header font size.
                            if (dynamicObject.headerFontSize != null)
                            {
                                tableHeaderFormat.FontSize = ConvertPixelToPoints(Convert.ToInt32(dynamicObject.headerFontSize));
                            }

                            //Applies table header font bold.
                            if (dynamicObject.headerFontBold != null)
                            {
                                tableHeaderFormat.Bold = dynamicObject.headerFontBold;
                            }

                            //Applies table header font color.
                            if (dynamicObject.headerFontColor != null)
                            {
                                tableHeaderFormat.TextColor = HexToRgb(dynamicObject.headerFontColor.ToString());
                            }
                            #endregion

                            #region Create TableBodyFormat
                            WCharacterFormat tableBodyFormat = new WCharacterFormat(dynamictable.Document);

                            //Applies table body font size
                            if (dynamicObject.tableBodyFontSize != null)
                            {
                                tableBodyFormat.FontSize = ConvertPixelToPoints(Convert.ToInt32(dynamicObject.tableBodyFontSize));
                            }

                            //Applies table body font color
                            if (dynamicObject.tableBodyFontColor != null)
                            {
                                tableBodyFormat.TextColor = HexToRgb(dynamicObject.tableBodyFontColor.ToString());
                            }
                            #endregion

                            //Find table by  text title in the document.
                            WTable foundTable = document.FindItemByProperty(EntityType.Table, "Title", paramName) as WTable;
                            if (foundTable != null)
                            {
                                foundTable.ApplyStyle("CustomStyle");
                            }

                            if (dynamicTable.tableHeaders != null)
                            {
                                for (var headerCell = 0; headerCell < dynamicTable.tableHeaders.Count; headerCell++)
                                {
                                    ChangeFormatting(foundTable.Rows[0].Cells[headerCell], tableHeaderFormat);

                                    //Applies table cell width
                                    if (dynamicObject.tableWidth != null)
                                    {
                                        foundTable.Rows[0].Cells[headerCell].Width = ConvertPixelToPoints(Convert.ToInt32(dynamicObject.tableWidth / dynamicTable.tableHeaders.Count));
                                    }

                                    //Applies text alignment
                                    if (dynamicObject.textAlign != null)
                                    {
                                        HorizontalAlignment horizontalAlignment = HorizontalAlignment.Left;
                                        if (dynamicObject.textAlign == "center")
                                        {
                                            horizontalAlignment = HorizontalAlignment.Center;
                                        }
                                        if (dynamicObject.textAlign == "right")
                                        {
                                            horizontalAlignment = HorizontalAlignment.Right;
                                        }
                                        //Iterates body items in table cell and set horizontal alignment.
                                        AlignCellContentForTextBody(foundTable.Rows[0].Cells[headerCell], horizontalAlignment);
                                    }
                                }
                            }
                            if (dynamicTable.tableBody != null && dynamicTable.tableBody.Count > 0)
                            {
                                int row = 1;
                                foreach (JObject rowData in dynamicTable.tableBody)
                                {
                                    WTableRow tableRow = dynamictable.AddRow(true);
                                    int cell = 0;
                                    foreach (JProperty prop in rowData.Properties())
                                    {
                                        ChangeFormatting(foundTable.Rows[row].Cells[cell], tableBodyFormat);

                                        //Applies table cell width
                                        if (dynamicObject.tableWidth != null)
                                        {
                                            foundTable.Rows[row].Cells[cell].Width = ConvertPixelToPoints(Convert.ToInt32(dynamicObject.tableWidth / dynamicTable.tableHeaders.Count));
                                        }

                                        //Applies text alignment
                                        if (dynamicObject.textAlign != null)
                                        {
                                            HorizontalAlignment horizontalAlignment = HorizontalAlignment.Left;
                                            if (dynamicObject.textAlign == "center")
                                            {
                                                horizontalAlignment = HorizontalAlignment.Center;
                                            }
                                            if (dynamicObject.textAlign == "right")
                                            {
                                                horizontalAlignment = HorizontalAlignment.Right;
                                            }
                                            //Iterates body items in table cell and set horizontal alignment.
                                            AlignCellContentForTextBody(foundTable.Rows[row].Cells[cell], horizontalAlignment);
                                        }
                                        cell++;
                                    }
                                    row++;
                                }
                            }
                        }

                        //Saves and closes the document
                        FileStream outputStream = new FileStream("Sample.docx", FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite);
                        document.Save(outputStream, FormatType.Docx);
                        Syncfusion.EJ2.DocumentEditor.WordDocument finaldocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Load(outputStream, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                        finaldocument.OptimizeSfdt = false;
                        string json = Newtonsoft.Json.JsonConvert.SerializeObject(finaldocument);
                        document.Dispose();
                        document.Close();
                        return json;

                    }
                }
                return null;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DynamicTableCreationInDocx", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }

        /// Converts pixel to points
        public float ConvertPixelToPoints(int pixel)

        {

            float point = pixel * 72 / 96;

            return point;

        }

        public Color HexToRgb(string hex)
        {
            hex = hex.TrimStart('#');

            if (hex.Length != 6)
            {
                // Handle invalid input gracefully
                // For example, return a default color
                return Color.Empty;
            }

            try
            {
                int r = Convert.ToInt32(hex.Substring(0, 2), 16);
                int g = Convert.ToInt32(hex.Substring(2, 2), 16);
                int b = Convert.ToInt32(hex.Substring(4, 2), 16);

                return Color.FromArgb(r, g, b);
            }
            catch (Exception)
            {
                // Handle any other exceptions here, if necessary
                // Return a default color or Color.Empty
                return Color.Empty;
            }
        }

        static void ChangeFormatting(WTableCell cell, WCharacterFormat characterFormat)
        {
            //Iterates through each of the child items of WTextBody
            for (int i = 0; i < cell.ChildEntities.Count; i++)
            {
                //IEntity is the basic unit in DocIO DOM. 
                //Accesses the body items (should be either paragraph, table or block content control) as IEntity
                IEntity bodyItemEntity = cell.ChildEntities[i];
                //A Text body has 3 types of elements - Paragraph, Table and Block Content Control
                //Decides the element type by using EntityType
                switch (bodyItemEntity.EntityType)
                {
                    case EntityType.Paragraph:
                        WParagraph paragraph = bodyItemEntity as WParagraph;
                        IterateParagraphAndChangeFormatting(paragraph.Items, characterFormat);
                        break;
                }
            }
        }
        static void IterateParagraphAndChangeFormatting(ParagraphItemCollection paraItems, WCharacterFormat characterFormat)
        {
            for (int i = 0; i < paraItems.Count; i++)
            {
                Entity entity = paraItems[i];
                //A paragraph can have child elements such as text, image, hyperlink, symbols, etc.,
                //Decides the element type by using EntityType
                switch (entity.EntityType)
                {
                    case EntityType.TextRange:
                        //Replaces the text with another
                        WTextRange textRange = entity as WTextRange;
                        textRange.CharacterFormat.FontSize = characterFormat.FontSize;
                        textRange.CharacterFormat.TextColor = characterFormat.TextColor;
                        textRange.CharacterFormat.Bold = characterFormat.Bold;
                        break;
                }
            }
        }

        private void AlignCellContentForTextBody(WTextBody textBody, HorizontalAlignment horizontalAlignment)
        {
            for (int i = 0; i < textBody.ChildEntities.Count; i++)
            {
                //IEntity is the basic unit in DocIO DOM. 
                //Accesses the body items as IEntity
                IEntity bodyItemEntity = textBody.ChildEntities[i];
                //A Text body has 3 types of elements - Paragraph, Table and Block Content Control
                //Decides the element type by using EntityType
                switch (bodyItemEntity.EntityType)
                {
                    case EntityType.Paragraph:
                        WParagraph paragraph = bodyItemEntity as WParagraph;
                        //Sets horizontal alignment for paragraph.
                        paragraph.ParagraphFormat.HorizontalAlignment = horizontalAlignment;
                        break;
                    case EntityType.Table:
                        //Table is a collection of rows and cells
                        //Iterates through table's DOM and set horizontal alignment.
                        AlignCellContentForTable(bodyItemEntity as WTable, horizontalAlignment);
                        break;
                    case EntityType.BlockContentControl:
                        BlockContentControl blockContentControl = bodyItemEntity as BlockContentControl;
                        //Iterates to the body items of Block Content Control and set horizontal alignment.
                        AlignCellContentForTextBody(blockContentControl.TextBody, horizontalAlignment);
                        break;
                }
            }
        }

        private void AlignCellContentForTable(WTable table, Syncfusion.DocIO.DLS.HorizontalAlignment horizontalAlignment)
        {
            //Iterates the row collection in a table
            foreach (WTableRow row in table.Rows)
            {
                //Iterates the cell collection in a table row
                foreach (WTableCell cell in row.Cells)
                {
                    //Iterate items in cell and set horizontal alignment
                    AlignCellContentForTextBody(cell, horizontalAlignment);
                }
            }
        }


        public async Task<List<TemplateOutputModel>> GetAllHTMLDataSet(bool IsArchived, string SearchText, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(_iconfiguration["MongoApiBaseUrl"] + "DataService/PdfDesignerApi/GetAllHTMLDataSet?IsArchived=" + IsArchived + "&SearchText=" + SearchText);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.Authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var templates = JsonConvert.DeserializeObject<List<TemplateOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        return templates;
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllHTMLDataSet", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<List<GenerateCompleteTemplatesOutputModel>> GetGeneratedInvoices(Guid GenericFormSubmittedId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SaveDataSource", "HTMLDataSetService"));


                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(_iconfiguration["MongoApiBaseUrl"] + "DataService/PdfDesignerApi/GetGeneratedInvoices?GenericFormSubmittedId=" + GenericFormSubmittedId);
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.Authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;

                        var generatedInvoices = JsonConvert.DeserializeObject<List<GenerateCompleteTemplatesOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));


                        return generatedInvoices;

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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGeneratedInvoices", "HTMLDataSetService", exception.Message), exception);
                return null;
            }
        }
        public List<FileConvertionOutputModel> FileConvertion(List<FileConvertionInputModel> inputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "FileConvertion", "HTMLDataSetService"));

                IMongoCollection<BsonDocument> datsetCollection = GetMongoCollectionObject<BsonDocument>("GeneratedInvoices");
                AggregateOptions aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                List<FileConvertionOutputModel> result = new List<FileConvertionOutputModel>();
                // Create the directory if it doesn't exist
                string folderPath = _iconfiguration["DocumentStorageLocalPath"];
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                foreach (FileConvertionInputModel input in inputModel)
                {
                    FileConvertionOutputModel output = new FileConvertionOutputModel
                    {
                        FileName = input.FileName,
                        GeneratedInvoicesId = input.GeneratedInvoicesId
                    };

                    List<BsonDocument> Pipeline = new List<BsonDocument>
                    {
                        new BsonDocument("$match",
                        new BsonDocument("_id", input.GeneratedInvoicesId.ToLower())),
                        new BsonDocument("$project",
                        new BsonDocument
                            {
                                { "_id", 0 },
                                { "SfdtTemplatesToDownload", 1 }
                            })
                    };
                    string sfdtString = null;

                    if (!string.IsNullOrWhiteSpace(input.SfdtJson))
                    {
                        sfdtString = input.SfdtJson;
                    }
                    else
                    {
                        var resultSet = datsetCollection.Aggregate<BsonDocument>(Pipeline, aggregateOptions).FirstOrDefault();

                        if (resultSet != null)
                        {
                            string data = resultSet.TryGetValue("SfdtTemplatesToDownload", out BsonValue sfdtStringBson) ? sfdtStringBson.ToString() : null;
                            sfdtString = data;
                        }
                    }

                    if (sfdtString != null)
                    {
                        Stream streamDocument = Syncfusion.EJ2.DocumentEditor.WordDocument.Save(sfdtString, Syncfusion.EJ2.DocumentEditor.FormatType.Docx);
                        WordDocument document = new WordDocument(streamDocument, FormatType.Automatic);
                        DocIORenderer renderer = new DocIORenderer();

                        // Convert Word document to PDF
                        PdfDocument pdfDocument = renderer.ConvertToPDF(document);
                        string uniqueFileName = Guid.NewGuid().ToString() + ".pdf";
                        string filePath = Path.Combine(folderPath, uniqueFileName);

                        // Create a file stream to save the document
                        using (FileStream outputStream1 = new FileStream(filePath, FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite))
                        {
                            try
                            {
                                pdfDocument.Save(outputStream1);
                                // Close the PDF document instance
                                pdfDocument.Close();
                                pdfDocument.Dispose();
                            }
                            catch (IOException ex)
                            {
                                Console.WriteLine("An error occurred in FileConvertion while saving the document: " + ex.Message);
                            }
                        }
                        output.Filetype = ".pdf";
                        output.FilePath = filePath;
                    }
                    else
                    {
                        LoggingManager.Error("Getting empty sfdtjson in FileConvertion");
                    }
                    result.Add(output);
                }

                return result;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "FileConvertion", "HTMLDataSetService", exception.Message), exception);
                return new List<FileConvertionOutputModel>();
            }
        }

        public string ByteArrayToPDFConvertion(ByteArrayToPDFConvertion inputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ByteArrayToPDFConvertion", "HTMLDataSetService"));
                string result = null;
                string folderPath = _iconfiguration["DocumentStorageLocalPath"];
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                if (inputModel != null && inputModel.FileBytes != null && inputModel.FileBytes.Count > 0)
                {
                    // Get the temporary directory path for storing the PDF
                    string uniqueFileName = Guid.NewGuid().ToString() + ".pdf";
                    string filePath = Path.Combine(folderPath, uniqueFileName);

                    using (PdfDocument document = new PdfDocument())
                    {
                        PdfPage page = document.Pages.Add(); // Initialize page outside the loop
                        float currentHeight = 0; // To keep track of the current height used on the page

                        foreach (var fileByte in inputModel.FileBytes.OrderBy(x => x.FileType))
                        {
                            string[] filebytes = fileByte.FileByteStrings.Split(',');
                            string[] fileContent = filebytes[0].Split(':');
                            string[] fileContentType = fileContent[1].Split(';');
                            byte[] bytes = null;

                            // Extract file name
                            string fileName = fileByte.VisualizationName;

                            // Check if the array contains enough elements before accessing them
                            if (fileContent.Length >= 2)
                            {
                                bytes = Convert.FromBase64String(filebytes[1]);
                            }

                            if (bytes != null)
                            {
                                using (MemoryStream ms = new MemoryStream(bytes))
                                {
                                    if (fileContentType[0] == "image/png")
                                    {
                                        PdfImage image = PdfImage.FromStream(ms);

                                        // Get the dimensions of the image
                                        float imageWidth = image.Width;
                                        float imageHeight = image.Height;

                                        // Calculate the scaling factor to fit the image width onto the page
                                        float scaleX = page?.GetClientSize().Width / imageWidth ?? document.PageSettings.Size.Width / imageWidth;

                                        // Calculate the new width and height of the scaled image
                                        float newWidth = imageWidth * scaleX;
                                        float newHeight = imageHeight * scaleX;

                                        // Check if adding the image exceeds the remaining space on the current page
                                        if (currentHeight + newHeight > (page?.GetClientSize().Height ?? document.PageSettings.Size.Height))
                                        {
                                            // If there is not enough space on the current page, add a new page
                                            page = document.Pages.Add();
                                            currentHeight = 0; // Reset the current height for the new page
                                        }

                                        // Draw file name
                                        PdfFont font = new PdfStandardFont(PdfFontFamily.Helvetica, 12);
                                        PdfGraphics graphics = page.Graphics;
                                        graphics.DrawString(fileName, font, PdfBrushes.Black, new PointF(10, currentHeight + 10));

                                        // Draw the scaled image on the page starting from the current position
                                        graphics.DrawImage(image, 3, currentHeight + 14 + font.Size, newWidth, newHeight);
                                        currentHeight += newHeight + 10 + font.Size; // Update the current height with some additional space
                                    }
                                    else if (fileContentType[0] == "application/pdf")
                                    {
                                        using (PdfLoadedDocument loadedDocument = new PdfLoadedDocument(ms))
                                        {
                                            foreach (PdfPageBase pdfPage in loadedDocument.Pages)
                                            {
                                                // Start a new page for each PDF page
                                                page = document.Pages.Add();

                                                // Draw the loaded PDF page on the current page
                                                PdfTemplate template = pdfPage.CreateTemplate();
                                                PointF position1 = new PointF(6, 9); // Adjust position as needed
                                                page.Graphics.DrawPdfTemplate(template, position1);

                                                // Update the current height with the height of the imported PDF content
                                                currentHeight += pdfPage.Size.Height;

                                                // Draw file name as header aligned left
                                                PdfFont font = new PdfStandardFont(PdfFontFamily.Helvetica, 12);
                                                PdfSolidBrush brush = new PdfSolidBrush(Color.Black);
                                                PdfStringFormat format = new PdfStringFormat();
                                                format.Alignment = PdfTextAlignment.Left;
                                                PointF position = new PointF(0, 0); // Adjust position as needed
                                                page.Graphics.DrawString(fileName, font, brush, position, format);
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Save the document to a file
                        using (FileStream fileStream = new FileStream(filePath, FileMode.Create, FileAccess.Write))
                        {
                            document.Save(fileStream);
                        }
                    }


                    result = filePath;
                    LoggingManager.Info("PDF created successfully.");
                }

                return result;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ByteArrayToPDFConvertion", "HTMLDataSetService", exception.Message), exception);
                return null;
            }
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
    }
}
