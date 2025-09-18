using BusinessView.Api.Models.OffersModel;
using BusinessView.Common;
using BusinessView.DAL;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;

namespace BusinessView.Api.Controllers.Api
{
    public class OffersController : ApiController
    {
        [HttpPost]
        [ActionName("SaveOffersOfEmployee")]
        [Authorize]
        public bool SaveOffersOfEmployee(List<OffersDto> employeeDetails)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    foreach (var offerDetails in employeeDetails)
                    {                    
                        var offerDetailsOfEmployee = new Offer
                        {
                            AdminId = offerDetails.AdminId,
                            OfferAmount = offerDetails.OfferAmount,
                            CreatedOn = DateTime.Now,
                            CreatedBy=offerDetails.AdminId,
                            EmployeeId=offerDetails.EmployeeId,
                            IsOfferApplicable=true
                        };

                        entities.Offers.Add(offerDetailsOfEmployee);

                        entities.SaveChanges();

                        var balanceOfferDetails = new BalanceOffer
                        {
                            OfferId=offerDetailsOfEmployee.Id,
                            AdminId=offerDetailsOfEmployee.AdminId,
                            EmployeeId=offerDetailsOfEmployee.EmployeeId,
                            BalanceAmount=offerDetailsOfEmployee.OfferAmount
                        };

                        entities.BalanceOffers.Add(balanceOfferDetails);

                        entities.SaveChanges();
                    }                    

                    return true;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return false;
            }
        }

        [HttpGet]
        [ActionName("GetEmployeeOfferDetails")]
        [Authorize]
        public async Task<List<OffersDto>> GetEmployeeOfferDetails(int userId)
        {
            var offerdetailsList = new List<OffersDto>();

            try
            {
                using (var entities = new BViewEntities())
                {
                    var offersList = await entities.Offers.Where(x => x.EmployeeId == userId).ToListAsync();

                    if (offersList.Count > 0)
                    {
                        foreach (var offers in offersList)
                        {
                            var offerDetails = await entities.BalanceOffers.Where(x => x.OfferId == offers.Id).FirstOrDefaultAsync();

                            if(offerDetails!=null)
                            {
                                var employeeOfferDetails = new OffersDto
                                {
                                    AdminId = offers.AdminId,
                                    CreatedBy = offers.CreatedBy,
                                    CreatedOn = offers.CreatedOn,
                                    EmployeeId = offers.EmployeeId,
                                    Id = offers.Id,
                                    IsOfferApplicable = offers.IsOfferApplicable,
                                    OfferAmount = offerDetails.BalanceAmount
                                };

                                offerdetailsList.Add(employeeOfferDetails);
                            }
                        }

                        return offerdetailsList;
                    }
                    return offerdetailsList;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return null;
            }
        }
    }
}