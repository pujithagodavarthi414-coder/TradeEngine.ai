using System.Collections.Generic;

namespace BusinessView.Api.Models.ChatModel
{
    public class DefaultEmployeeDetailsDto
    {
        public List<string> Roles { get; set; }
        public List<string> Locations { get; set; }
        public List<string> TimeZones { get; set; }
    }
}