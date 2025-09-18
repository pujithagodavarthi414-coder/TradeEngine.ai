using System.ComponentModel.DataAnnotations;

namespace Btrak.Models
{
    public class LoginModel
    {
        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Please enter valid email address.")]
        public string UserName
        {
            get;
            set;
        }

        [Required(ErrorMessage = "Password is required")]
        [DataType(DataType.Password)]
        public string Password
        {
            get;
            set;
        }

        public string Name { get; set; }

        public string Image { get; set; }

        public bool IsLiteLogin { get; set; }
        public string HostAddress { get; set; }
        public string RequestedUrl { get; set; }
    }
}
