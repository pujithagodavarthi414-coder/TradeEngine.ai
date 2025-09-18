using System;
using System.ComponentModel.DataAnnotations;

namespace Btrak.Models
{
   public  class EmployeeQualificationModel
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
        [Required(ErrorMessage = "Please enter Company Name")]
        public string Company
        {
            get;
            set;
        }

        public string Designation
        {
            get;
            set;
        }


        public Guid DesignationId
        {
            get;
            set;
        }
        [Required(ErrorMessage = "Please enter From Date")]
        public DateTime? FromDate
        {
            get;
            set;
        }
        public DateTime? ToDate
        {
            get;
            set;
        }
        public string Comments
        {
            get;
            set;
        }
        public int LevelId
        {
            get;
            set;
        }
        public string LevelName
        {
            get;
            set;
        }
        public string Institute
        {
            get;
            set;
        }
        public string Specialization
        {
            get;
            set;
        }
        public decimal Percentage
        {
            get;
            set;
        }
        public DateTime? StartDate
        {
            get;
            set;
        }
        public DateTime? EndDate
        {
            get;
            set;
        }
        public string Year
        {
            get;
            set;
        }

        public int SkillId
        {
            get;
            set;
        }
        public string SkillName
        {
            get;
            set;
        }
        public string Experience
        {
            get;
            set;
        }
        public int LanguageId
        {
            get;
            set;
        }
        public string LangauageName
        {
            get;
            set;
        }
        public int FluencyId
        {
            get;
            set;
        }
        public string FluencyName
        {
            get;
            set;
        }
        public int CompetencyId
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
