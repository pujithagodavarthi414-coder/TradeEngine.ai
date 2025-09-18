
using PDFHTMLDesignerModels;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc.ModelBinding;

namespace PDFHTMLDesigner.Models
{
    public class DataJsonResult
    {
        public object Data
        {
            get;
            set;
        }

        public DataJsonResult(ModelStateDictionary modelState)
        {
            Success = false;

            ApiResponseMessages = new List<ApiResponseMessage>();
            foreach (var modelStateKey in modelState.Keys)
            {
                foreach (ModelError error in modelState[modelStateKey].Errors)
                {
                    ApiResponseMessages.Add(new ApiResponseMessage
                    {
                        FieldName = modelStateKey,
                        Message = error.ErrorMessage,
                        MessageTypeEnum = MessageTypeEnum.Error
                    });
                }
            }
        }

        public DataJsonResult(string message)
        {
            Success = false;
            ApiResponseMessages = new List<ApiResponseMessage>
            {
                new ApiResponseMessage
                {
                    Message = message,
                    MessageTypeEnum = MessageTypeEnum.Error
                }
            };
        }
        public ModelStateDictionary ModelState
        {
            get;
            set;
        }

        public DataJsonResult()
        {
            Success = true;
            ApiResponseMessages = new List<ApiResponseMessage>();
        }

        public List<ApiResponseMessage> ApiResponseMessages { get; set; }

        public string Result
        {
            get;
            set;
        }

        public bool Success
        {
            get;
            set;
        }

        public string VersionNumber
        {
            get;
            set;
        }

        public bool IsLatestVersion
        {
            get;
            set;
        }
    }
}
