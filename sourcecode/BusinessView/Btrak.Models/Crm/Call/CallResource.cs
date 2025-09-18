using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Crm.Call
{
    public class CallResourceModel
    {
        public DateTime? DateUpdated { get; set; }
        public string Sid { get; set; }
        public string AccountSid { get; set; }
        public string To { get; set; }
        public string ToFormatted { get; set; }
        public string From { get; set; }
        public string FromFormatted { get; set; }
        public string PhoneNumberSid { get; set; }
        public string Status { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public string Duration { get; set; }
        public DateTime? DateCreated { get; set; }
        public string Price { get; set; }
        public string Direction { get; set; }
        public string AnsweredBy { get; set; }
        public string Annotation { get; set; }
        public string ApiVersion { get; set; }
        public string ForwardedFrom { get; set; }
        public string GroupSid { get; set; }
        public string CallerName { get; set; }
        public string QueueTime { get; set; }
        public string TrunkSid { get; set; }
        public string Uri { get; set; }
        public Dictionary<string, string> SubresourceUris { get; set; }
        public string PriceUnit { get; set; }
        public string ParentCallSid { get; set; }
        public Dictionary<string, string> RecordingURLs { get; set; }
    }

    public sealed class StatusEnum
    {
        public static readonly StatusEnum Queued;
        public static readonly StatusEnum Ringing;
        public static readonly StatusEnum InProgress;
        public static readonly StatusEnum Completed;
        public static readonly StatusEnum Busy;
        public static readonly StatusEnum Failed;
        public static readonly StatusEnum NoAnswer;
        public static readonly StatusEnum Canceled;
    }
}
