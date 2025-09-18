using System.Web.Http.ModelBinding;

namespace BTrak.Api.Models
{
    public class IncorrectPasswordModel
    {
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

        public object Data
        {
            get;
            set;
        }
        public ModelStateDictionary ModelState
        {
            get;
            set;
        }
    }
}