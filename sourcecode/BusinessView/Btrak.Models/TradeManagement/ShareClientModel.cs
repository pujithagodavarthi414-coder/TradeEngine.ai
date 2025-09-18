using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class ShareClientModel
    {
        public Guid? ClientId { get; set; }
        public string Status { get; set; }
        public string Comments { get; set; }
        public string FullName { get; set; }
        public DateTime? Date { get; set; }
    }
    public class ShareDocumentsHistoryModel
    {
        public List<DocumentModel> SharedDocuments { get; set; }
        public Guid ClientTypeId { get; set; }
        public string ClientType{ get; set; }
        public DateTime CreatedDateTime { get; set; }
        public List<Guid> ClientIds { get; set; }
    }
}
