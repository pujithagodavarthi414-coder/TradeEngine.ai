using Btrak.Models;
using System;
using System.Collections.Generic;
using System.Web.Http.ModelBinding;

namespace BTrak.Api.Models
{
    public class ProjectJsonResult
    {
        public Guid ProjectId { get; set; }
        public string ValidationMessage { get; set; }
        public bool Success
        {
            get;
            set;
        }

        public ProjectJsonResult()
        {
            Success = true;                      
        }
        public List<ApiResponseMessage> ApiResponseMessages { get; set; }
        public ProjectJsonResult(ModelStateDictionary modelState)
        {
            Success = false;

            ApiResponseMessages = new List<ApiResponseMessage>();
            foreach (var modelStateKey in modelState.Keys)
            {
                foreach (ModelError error in modelState[modelStateKey].Errors)
                {
                    ApiResponseMessages.Add(new ApiResponseMessage()
                    {
                        FieldName = modelStateKey,
                        Message = error.ErrorMessage,
                        MessageTypeEnum = MessageTypeEnum.Error
                    });
                }
            }

        }
    }
   
}