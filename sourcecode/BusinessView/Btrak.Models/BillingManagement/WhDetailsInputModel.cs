using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class WhDetailsInputModel
    {
        public string FinalVehicleNumberOfTransporter { get; set; }
        public string FinalMobileNumberOfTruckDriver { get; set; }
        public Guid? FinalPortId { get; set; }
        public int FinalDrums { get; set; }
        public string FinalBLNumber { get; set; }
        public float FinalQuantityInMT { get; set; }
        public float FinalNetWeightApprox { get; set; }
        public string WeighingSlipNumber { get; set; }
        public string WeighingSlipDate { get; set; }
        public string WeighingSlipPhoto { get; set; }
        public string UploadedOther { get; set; }
        public Guid? UserId { get; set; }
        public Guid? LeadId { get; set; }

    }
}
