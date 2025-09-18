using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Chat
{
    public  class WebHookInputModel
    {
        public string ReportMessage { get; set; }
        public string WebUrl { get; set; }
        public Guid SenderId { get; set; }
    }
}
