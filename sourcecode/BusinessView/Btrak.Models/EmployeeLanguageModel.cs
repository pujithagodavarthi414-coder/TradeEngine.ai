using System;

namespace Btrak.Models
{
   public  class EmployeeLanguageModel
    {
        public Guid Id
        {
            get;
            set;
        }
        public Guid EmployeeId
        {
            get;
            set;
        }
        public string Comments
        {
            get;
            set;
        }
        public Guid LanguageLevelId
        {
            get;
            set;
        }
        public string LangauageName
        {
            get;
            set;
        }
 
        public Guid FluencyId
        {
            get;
            set;
        }
        public string FluencyName
        {
            get;
            set;
        }
       
        public Guid CompetencyId
        {
            get;
            set;
        }
        public string CompetencyName
        {
            get;
            set;
        }
        public string loggedusername
        {
            get;
            set;
        }
    }
}
