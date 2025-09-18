using BTrak.Common;
using Btrak.Models.FormDataServices;
using Btrak.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Headers;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web.Configuration;
using Btrak.Models.GenericForm;
using Newtonsoft.Json.Linq;

namespace Btrak.Services.PDFHTMLDesigner
{
    public class PDFHTMLDesignerService : IPDFHTMLDesignerService
    {
        public PDFHTMLDesignerService() 
        { 

        }

        public async Task<List<FileConvertionOutputModel>> FileConvertion(List<FileConvertionInputModel> InputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["PDFHTMLDesignerApiBaseUrl"] + "PDFDocumentEditor/HTMLDataSetApi/FileConvertion");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(InputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<FileConvertionOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        return result;
                    }
                    else
                    {
                        validationmessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });
                        return new List<FileConvertionOutputModel>();
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "FileConvertion", " DataSetService", exception.Message), exception);
                return new List<FileConvertionOutputModel>();
            }
        }

        public async Task<string> ByteArrayToPDFConvertion(ShareDashBoardAsPDFInputModel InputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["PDFHTMLDesignerApiBaseUrl"] + "PDFDocumentEditor/HTMLDataSetApi/ByteArrayToPDFConvertion");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(InputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<string>(JsonConvert.SerializeObject(dataSetResponse));
                        return result;
                    }
                    else
                    {
                        validationmessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "FileConvertion", " DataSetService", exception.Message), exception);
                return null;
            }
        }

    }
}
