using System;

namespace AuthenticationServices.Models
{
    public class UserAuthToken
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public Guid CompanyId { get; set; }
        public string UserName { get; set; }
        public DateTime? DateCreated { get; set; }
        public string AuthToken { get; set; }
        public Guid OriginalId { get; set; }
    }
}
