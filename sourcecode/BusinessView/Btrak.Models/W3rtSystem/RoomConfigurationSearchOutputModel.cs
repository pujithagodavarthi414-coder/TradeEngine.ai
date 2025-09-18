using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.W3rtSystem
{
    public class RoomConfigurationSearchOutputModel
    {
        public Guid? RoomId { get; set; }
        public string RoomName { get; set; }
        public Guid? OrganisationId { get; set; }
        public string OrganisationName { get; set; }
        public Guid? VenueId { get; set; }
        public string VenueName { get; set; }
        public string ImageJson { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string Video { get; set; }
        public string Description { get; set; }
        public string Town { get; set; }
        public string Locality { get; set; }
        public decimal Price { get; set; }
        public decimal Tax { get; set; }
        public decimal DepositAmount { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public int TotalCount { get; set; }
        public decimal RoomCost { get; set; }
       
    }
}
