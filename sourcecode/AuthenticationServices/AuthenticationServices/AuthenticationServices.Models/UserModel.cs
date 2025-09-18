using System;
using System.ComponentModel.DataAnnotations;

namespace AuthenticationServices.Models
{
    public class UserModel : UserMiniModel
    {
        public bool RememberMe
        {
            get;
            set;
        }


        public string MobileNo
        {
            get;
            set;
        }

        public bool? IsPasswordForceReset
        {
            get;
            set;
        }

        [Required(ErrorMessage = "Please enter an email address.")]
        [EmailAddress(ErrorMessage = "Please enter a valid email address.")]
        public string UserName
        {
            get;
            set;
        }

        [Required]
        [DataType(DataType.Password)]
        public string Password
        {
            get;
            set;
        }
        public string Token { get; set; }

        public Guid CompanyGuid { get; set; }

        //public Guid RoleId { get; set; }

        public Guid CompanyId
        {
            get;
            set;
        }
        public bool IsAdmin { get; set; }
        public string ClientId { get; set; }
        public string Scope { get; set; }
    }
}
