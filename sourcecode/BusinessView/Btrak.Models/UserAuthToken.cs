using System;

namespace Btrak.Models
{
    public class UserAuthToken
    {
        public System.Guid Id { get; set; }
        public System.Guid UserId { get; set; }
        public System.Guid CompanyId { get; set; }
        public string UserName { get; set; }
        public DateTime? DateCreated { get; set; }
        public string AuthToken { get; set; }
        public System.Guid OriginalId { get; set; }
    }
}
