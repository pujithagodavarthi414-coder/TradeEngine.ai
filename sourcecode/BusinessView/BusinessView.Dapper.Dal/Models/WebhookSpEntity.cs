using System;

namespace Btrak.Dapper.Dal.Models
{
    public class WebhookSpEntity
    {
        public Guid WebHookId { get; set; }
        public Guid? UserId { get; set; }
        public Guid? ProjectId { get; set; }
        public string WebHookUrl { get; set; }
    }
}
