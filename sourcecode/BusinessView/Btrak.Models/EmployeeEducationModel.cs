using System;
using System.ComponentModel.DataAnnotations;

namespace Btrak.Models
{
   public  class EmployeeEducationModel
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

        public Guid EducationLevelId
        {
            get;
            set;
        }
        public string EducationLevel
        {
            get;
            set;
        }
        [Required(ErrorMessage = "Please enter Institute")]
        public string Institute
        {
            get;
            set;
        }
        public string MajorSpecilalization
        {
            get;
            set;
        }
        [Required(ErrorMessage = "Please enter GPA")]
        public decimal GPA_Score
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
    }
}
