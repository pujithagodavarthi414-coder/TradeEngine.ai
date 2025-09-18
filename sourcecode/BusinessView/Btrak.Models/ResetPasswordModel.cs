using System;
using System.ComponentModel.DataAnnotations;

namespace Btrak.Models
{
    public class ResetPasswordModel
    {
        public Guid ResetPasswordId
        {
            get;
            set;
        }

        public DateTime? CreatedOn
        {
            get;
            set;
        }

        public DateTime? ExpiredOn
        {
            get;
            set;
        }
       
        public bool? IsExpired
        {
            get;
            set;
        }

        [Display(Name = "Password")]
        [DataType(DataType.Password)]
        public string Password
        {
            get;
            set;
        }

        [Required(ErrorMessage = "New Password is required")]
        [StringLength(50, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 8)]
        [DataType(DataType.Password)]
        public string NewPassword
        {
            get;
            set;
        }
        [Required(ErrorMessage = "Confirm Password is required")]
        [DataType(DataType.Password)]
        [Display(Name = "Confirm password")]
        [Compare("NewPassword", ErrorMessage = "The password and confirmation password do not match.")]
        public string ConfirmPassword
        {
            get;
            set;
        }

        public Guid ResetGuid
        {
            get;
            set;
        }

        public Guid UserId
        {
            get;
            set;
        }

        public string FullName { get; set; }
        public string UserName { get; set; }
        public Guid? LoggedUserId { get; set; }
        public int? Type { get; set; }
    }
}
