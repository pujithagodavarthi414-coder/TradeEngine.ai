
using System.Web.Http.ModelBinding;

namespace BusinessView.Api.Models
{
    public class BusinessViewJsonResult
    {
        public object Data
        {
            get;
            set;
        }

        public BusinessViewJsonResult(ModelStateDictionary modelState)
        {
            Success = false;
            ModelState = modelState;
        }

        public BusinessViewJsonResult()
        {
            Success = true;
        }

        public ModelStateDictionary ModelState
        {
            get;
            set;
        }

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
    }
}
