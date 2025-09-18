using System;

namespace AuthenticationServices.Common
{
    public class LoggedInContext
    {
        public Guid LoggedInUserId { get; set; }
        public int? TimeZoneOffset { get; set; }
        public Guid CompanyGuid { get; set; }
        public string RequestedHostAddress { get; set; }

        public string CurrentUrl { get; set; }
        public string TimeZoneString { get; set; }

        public override string ToString()
        {
            return $"LoggedInUserId = {LoggedInUserId}, Company Id = {CompanyGuid}, RequestedHostAddress={RequestedHostAddress}";
        }
    }
}
