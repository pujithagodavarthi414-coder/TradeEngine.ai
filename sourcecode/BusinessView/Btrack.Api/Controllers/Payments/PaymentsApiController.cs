using Btrak.Models;
using Btrak.Models.Crm.Payment;
using Btrak.Services.Payment;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Stripe;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;


namespace BTrak.Api.Controllers.Payments
{
    public class PaymentsApiController : AuthTokenApiController
    {
        private readonly IPaymentService _paymentService;
        private readonly UserAuthTokenFactory _userAuthTokenFactory;
        public PaymentsApiController(IPaymentService paymentService)
        {
            _paymentService = paymentService;
            _userAuthTokenFactory = new UserAuthTokenFactory();
        }

        [AllowAnonymous]
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCompanyPayment)]
        public JsonResult<BtrakJsonResult> UpsertCompanyPayment(CompanyPaymentUpsertInputModel companyPaymentUpsertInputModel)
        {
            var validationMessages = new List<ValidationMessage>();

            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCompanyPayment", "Payments Api"));

                BtrakJsonResult btrakJsonResult;
                Guid? companyPaymentIdReturned = null;

                if (companyPaymentUpsertInputModel != null)
                {
                    StripeConfiguration.ApiKey = ConfigurationManager.AppSettings.Get("StripeApiKey");
                    var stripeToken = companyPaymentUpsertInputModel.StripeTokenId;

                    // Create customer
                    var customerOptions = new CustomerCreateOptions
                    {
                        Description = "Name : " + companyPaymentUpsertInputModel.CardHolderName + " - Email : " + companyPaymentUpsertInputModel.Email + " ",
                        Name = companyPaymentUpsertInputModel.CardHolderName,
                        Email = companyPaymentUpsertInputModel.Email,
                        Source = stripeToken,
                        Address = new AddressOptions
                        {
                            Line1 = companyPaymentUpsertInputModel.AddressOptions.Address_line1,
                            Line2 = companyPaymentUpsertInputModel.AddressOptions.Address_line1,
                            PostalCode = companyPaymentUpsertInputModel.AddressOptions.Address_zip,
                            City = companyPaymentUpsertInputModel.AddressOptions.Address_city,
                            State = companyPaymentUpsertInputModel.AddressOptions.Address_state,
                            Country = companyPaymentUpsertInputModel.AddressOptions.Address_country,
                        },
                    };
                    var Customerservice = new CustomerService();
                    var customer = Customerservice.Create(customerOptions);

                    var options = new ProductListOptions
                    {
                        Active = true
                    };
                    var service = new ProductService();
                    StripeList<Product> products = service.List(
                      options
                    );
                    var product = new Product();
                    var productFindObj = (products != null && products.Data != null) ?
                        products.Data.Find(x => x.Name == companyPaymentUpsertInputModel.PlanName + "-" + companyPaymentUpsertInputModel.SubscriptionType) : null;

                    if (productFindObj == null)
                    {
                        // Create product 
                        var produceOptions = new ProductCreateOptions
                        {
                            Name = companyPaymentUpsertInputModel.PlanName + "-" + companyPaymentUpsertInputModel.SubscriptionType,
                        };
                        var productService = new ProductService();
                        product = productService.Create(produceOptions);
                    }
                    else
                        product = productFindObj;

                    // Create pricing...
                    var pricingOptions = new PriceCreateOptions
                    {
                        UnitAmount = 100 * Convert.ToInt32(companyPaymentUpsertInputModel.TotalAmount),
                        Currency = "GBP",
                        Recurring = new PriceRecurringOptions
                        {
                            Interval = companyPaymentUpsertInputModel.SubscriptionType,
                        },
                        Product = product.Id,
                    };
                    var pricingService = new PriceService();
                    var pricing = pricingService.Create(pricingOptions);


                    var subscriptionId = _paymentService.GetSubscriptionId(null, validationMessages);
                    if (subscriptionId != null)
                    {
                        DateTimeOffset prorationDate = DateTimeOffset.UtcNow;

                        var subService = new SubscriptionService();
                        Subscription subscription = subService.Get(subscriptionId);


                        var items = new List<SubscriptionItemOptions> {
                                        new SubscriptionItemOptions {
                                             Id = subscription.Items.Data[0].Id,
                                             Price = pricing.Id,
                        },
                        };

                        var subOptions = new SubscriptionUpdateOptions
                        {
                            CancelAtPeriodEnd = false,
                            ProrationBehavior = "create_prorations",
                            Items = items,
                        };
                        subscription = subService.Update(subscriptionId, subOptions);

                        companyPaymentUpsertInputModel.StripeTokenId = stripeToken;
                        companyPaymentUpsertInputModel.StripeCustomerId = customer.Id;
                        companyPaymentUpsertInputModel.Status = "Updated";
                        companyPaymentUpsertInputModel.PricingId = pricing.Id;
                        companyPaymentUpsertInputModel.SubscriptionId = subscription.Id;
                        companyPaymentUpsertInputModel.IsUpdate = true;
                        companyPaymentIdReturned = SaveCompanyPaymentDetails(companyPaymentUpsertInputModel, validationMessages);
                    }
                    else
                    {
                        // subsription..
                        var subscriptionOptions = new SubscriptionCreateOptions
                        {
                            Customer = customer.Id,
                            Items = new List<SubscriptionItemOptions>
                                {
                                    new SubscriptionItemOptions
                                      {
                                          Price = pricing.Id,
                                      },
                                },
                        };
                        var subscriptionService = new SubscriptionService();
                        var subscription = subscriptionService.Create(subscriptionOptions);

                        companyPaymentUpsertInputModel.StripeTokenId = stripeToken;
                        companyPaymentUpsertInputModel.StripeCustomerId = customer.Id;
                        companyPaymentUpsertInputModel.Status = subscription.Status;
                        companyPaymentUpsertInputModel.PricingId = pricing.Id;
                        companyPaymentUpsertInputModel.SubscriptionId = subscription.Id;
                        if (subscription.Status == "active")
                            companyPaymentUpsertInputModel.IsSubscriptionDone = true;
                        companyPaymentUpsertInputModel.StartTime = DateTime.UtcNow;
                        companyPaymentUpsertInputModel.EndTime = null;

                        companyPaymentIdReturned = SaveCompanyPaymentDetails(companyPaymentUpsertInputModel, validationMessages);
                    }
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanyPayment", "Payments Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult?.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanyPayment", "Payments Api"));

                return Json(new BtrakJsonResult { Data = companyPaymentIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertBranch, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CancelSubscription)]
        public JsonResult<BtrakJsonResult> CancelSubscription()
        {
            var validationMessages = new List<ValidationMessage>();

            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CancelSubscription", "Payments Api"));

                BtrakJsonResult btrakJsonResult;

                var subscriptionId = string.Empty;
                var ah = Request.Headers.Authorization;
                if (ah != null && ah.Scheme.ToLower() == "bearer")
                {
                    var jwtToken = ah.Parameter;

                    var decodeJwt = jwtToken != "null" ? _userAuthTokenFactory.DecodeUserAuthToken(jwtToken) : null;
                    if (decodeJwt != null)
                    {
                        var loggedInUserId = decodeJwt.UserId;
                        subscriptionId = _paymentService.GetSubscriptionId(loggedInUserId, validationMessages);
                    }
                    else
                        subscriptionId = _paymentService.GetSubscriptionId(null, validationMessages);
                }
                else
                {
                    subscriptionId = _paymentService.GetSubscriptionId(null, validationMessages);
                }

                if (subscriptionId != null)
                {
                    StripeConfiguration.ApiKey = ConfigurationManager.AppSettings.Get("StripeApiKey");

                    var subscriptionService = new SubscriptionService();
                    var subscription = subscriptionService.Cancel(subscriptionId);
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CancelSubscription", "Payments Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult?.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CancelSubscription", "Payments Api"));

                return Json(new BtrakJsonResult { Data = subscriptionId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionCancelSubscription, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllTransactionDetails)]
        public JsonResult<BtrakJsonResult> GetAllTransactionDetails(CompanyPaymentUpsertInputModel companyPaymentUpsertInputModel)
        {
            var validationMessages = new List<ValidationMessage>();

            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInvoiceDetails", "Payments Api"));

                BtrakJsonResult btrakJsonResult;
                StripeList<Invoice> invoices = new StripeList<Invoice>();
                var invoiceLists = new List<PaymentAndInvoiceOutputModel>();
                if(companyPaymentUpsertInputModel.TransactionName == "Invoices" || companyPaymentUpsertInputModel.TransactionName == "All")
                {
                    List<string> subscriptionIds = _paymentService.GetAllSubscriptionIds(LoggedInContext, validationMessages);
                    subscriptionIds.ForEach(subscriptionId =>
                    {
                        
                        StripeConfiguration.ApiKey = ConfigurationManager.AppSettings.Get("StripeApiKey");

                        var options = new InvoiceListOptions
                        {
                            Subscription = subscriptionId,
                        };
                        var invoicesService = new InvoiceService();
                        invoices = invoicesService.List(options);
                        if (invoices != null && invoices.Data.Count > 0)
                        {
                            invoices.Data.ForEach(x =>
                            {
                                var productId = x.Lines.Data?[0].Plan.ProductId;

                                var service = new ProductService();
                                var productObj = productId != null ? service.Get(productId) : null;

                                var invoiceObj = new PaymentAndInvoiceOutputModel();
                                invoiceObj.InvoiceId = x.Id;
                                invoiceObj.Details = "Invoice #" + x.Number;
                                invoiceObj.Product = productObj?.Name;
                                invoiceObj.Status = x.Status;
                                invoiceObj.Amount = x.AmountPaid / 100;
                                invoiceObj.AmountDue = x.AmountDue / 100;
                                invoiceObj.CreatedDateTime = x.Created.Date;
                                invoiceObj.InvoiceNumber = x.Number;
                                invoiceObj.PdfUrl = x.InvoicePdf;
                                invoiceLists.Add(invoiceObj);
                            });
                        }
                    });
                }
                if (companyPaymentUpsertInputModel.TransactionName == "Payments" || companyPaymentUpsertInputModel.TransactionName == "All")
                {
                    List<string> customerIds = _paymentService.GetAllCustomerIds(LoggedInContext, validationMessages);
                    customerIds.ForEach(customerId =>
                    {
                        var chargeOptions = new ChargeListOptions { Customer = customerId };
                        var service = new ChargeService();
                        StripeList<Charge> charges = service.List(
                          chargeOptions
                        );
                        if (charges != null && charges.Data.Count > 0)
                        {
                            charges.Data.ForEach(payment =>
                            {
                                var invoiceService = new InvoiceService();
                                var invoice = invoiceService.Get(payment.InvoiceId);

                                var productId = invoice?.Lines.Data?[0].Plan.ProductId;

                                var productService = new ProductService();
                                var productObj = productId != null ? productService.Get(productId) : null;

                                var invoiceObj = new PaymentAndInvoiceOutputModel();
                                invoiceObj.InvoiceId = payment.Id;
                                invoiceObj.Details = "Payment #" + (payment.ReceiptNumber ?? payment.PaymentIntentId);
                                invoiceObj.Product = productObj?.Name;
                                invoiceObj.Status = payment.Status;
                                invoiceObj.Amount = payment.Amount / 100;
                                invoiceObj.CreatedDateTime = payment.Created.Date;
                                invoiceObj.InvoiceNumber = payment.ReceiptNumber;
                                invoiceObj.PdfUrl = payment.ReceiptUrl;
                                invoiceLists.Add(invoiceObj);
                            });
                        }
                    });
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllTransactionDetails", "Payments Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult?.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllTransactionDetails", "Payments Api"));

                return Json(new BtrakJsonResult { Data = invoiceLists, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionCancelSubscription, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [AllowAnonymous]
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetPurchasedLicencesCount)]
        public JsonResult<BtrakJsonResult> GetPurchasedLicencesCount()
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPurchasedLicencesCount", "Payments Api"));

                BtrakJsonResult btrakJsonResult;
                var result = new CompanyPaymentUpsertOutputModel();
                Guid? loggedInUser = null;
                var ah = Request.Headers.Authorization;
                if (ah != null && ah.Scheme.ToLower() == "bearer")
                {
                    var jwtToken = ah.Parameter;

                    var decodeJwt = jwtToken != "null" ? _userAuthTokenFactory.DecodeUserAuthToken(jwtToken) : null;
                    if (decodeJwt != null)
                    {
                        loggedInUser = decodeJwt.UserId;
                        result = _paymentService.GetPurchasedLicencesCount(loggedInUser, validationMessages);
                    }
                    else
                        result = _paymentService.GetPurchasedLicencesCount(null, validationMessages);
                }
                else
                {
                    result = _paymentService.GetPurchasedLicencesCount(null, validationMessages);
                }
                if (result != null)
                {
                    var subscriptionId = _paymentService.GetSubscriptionId(loggedInUser, validationMessages);
                    if (subscriptionId != null)
                    {
                        var subscriptionService = new SubscriptionService();
                        var subscriptionObj = subscriptionService.Get(subscriptionId);
                        if (subscriptionObj != null)
                            result.RenewalDate = subscriptionObj.CurrentPeriodEnd;
                    }
                }


                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPurchasedLicencesCount", "Payments Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPurchasedLicencesCount", "Payments Api"));
                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPurchasedLicencesCount", "Payments Api", exception.Message), exception);
                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPaymentHistory)]
        public JsonResult<BtrakJsonResult> GetPaymentHistory()
        {
            var validationMessages = new List<ValidationMessage>();

            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStriePaymentDetails", "Payments Api"));

                BtrakJsonResult btrakJsonResult;

                List<CompanyPaymentUpsertInputModel> paymentHistory = _paymentService.GetPaymentHistory(LoggedInContext, validationMessages);
                paymentHistory.ForEach(x =>
                {
                    var subService = new SubscriptionService();
                    Subscription subscription = subService.Get(x.SubscriptionId);

                    x.StartTime = subscription.CurrentPeriodStart.Date;
                    x.EndTime = subscription.CurrentPeriodEnd.Date;
                    x.CancelledDate = subscription.CanceledAt;
                });


                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStriePaymentDetails", "Payments Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult?.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStriePaymentDetails", "Payments Api"));

                return Json(new BtrakJsonResult { Data = paymentHistory, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionCancelSubscription, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [AllowAnonymous]
        [Route(RouteConstants.Webhook)]
        public HttpResponseMessage StripeWebHookApi()
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "StripeWebHookApi", "Request", Request, "Payment Api"));
            var validationMessages = new List<ValidationMessage>();

            try
            {
                string json;
                using (StreamReader reader = new StreamReader(HttpContext.Current.Request.InputStream))
                {
                    json = reader.ReadToEnd();
                }
                var stripeEvent = EventUtility.ParseEvent(json);

                if (stripeEvent.Type == Events.InvoicePaid)
                {
                    var InvoiceSucceededModel = stripeEvent.Data.Object as Invoice;
                    if (InvoiceSucceededModel?.BillingReason == "subscription_create")
                    {
                        var invoiceAutoInputModel = new CompanyPaymentUpsertInputModel();
                        invoiceAutoInputModel.SubscriptionId = InvoiceSucceededModel.SubscriptionId;
                        invoiceAutoInputModel.InvoiceId = InvoiceSucceededModel.Id;
                        var companyPaymentIdReturned = _paymentService.UpdateInvoiceId(invoiceAutoInputModel, validationMessages);
                        return new HttpResponseMessage(HttpStatusCode.OK);
                    }
                    else if (InvoiceSucceededModel?.BillingReason == "subscription_cycle")
                    {
                        var invoiceAutoInputModel = new CompanyPaymentUpsertInputModel();
                        invoiceAutoInputModel.InvoiceId = InvoiceSucceededModel.Id;
                        invoiceAutoInputModel.StripeCustomerId = InvoiceSucceededModel.CustomerId;
                        invoiceAutoInputModel.Status = InvoiceSucceededModel.Status;
                        invoiceAutoInputModel.SubscriptionId = InvoiceSucceededModel.SubscriptionId;
                        invoiceAutoInputModel.IsRenewal = InvoiceSucceededModel.Paid ? true : false;
                        if (InvoiceSucceededModel.Status == "paid")
                            invoiceAutoInputModel.IsSubscriptionDone = true;
                        invoiceAutoInputModel.TotalAmount = InvoiceSucceededModel.AmountPaid / 100;
                        invoiceAutoInputModel.PricingId = InvoiceSucceededModel.Lines.Data?[0].Price.Id;
                        var companyPaymentIdReturned = _paymentService.SaveBillingDetails(invoiceAutoInputModel, validationMessages);
                        return new HttpResponseMessage(HttpStatusCode.OK);
                    }

                }
                else if (stripeEvent.Type == Events.InvoicePaymentFailed)
                {
                    var invoiceFailedModel = stripeEvent.Data.Object as Invoice;
                    var invoiceAutoInputModel = new CompanyPaymentUpsertInputModel();
                    invoiceAutoInputModel.InvoiceId = invoiceFailedModel.Id;
                    invoiceAutoInputModel.StripeCustomerId = invoiceFailedModel.CustomerId;
                    invoiceAutoInputModel.Status = "Invoice failed";
                    invoiceAutoInputModel.SubscriptionId = invoiceFailedModel.SubscriptionId;
                    invoiceAutoInputModel.IsRenewal = false;
                    if (invoiceFailedModel.Status == "paid")
                        invoiceAutoInputModel.IsSubscriptionDone = true;
                    invoiceAutoInputModel.TotalAmount = invoiceFailedModel.AmountPaid / 100;
                    invoiceAutoInputModel.PricingId = invoiceFailedModel.Lines.Data?[0].Price.Id;
                    var companyPaymentIdReturned = _paymentService.SaveBillingDetails(invoiceAutoInputModel, validationMessages);
                    return new HttpResponseMessage(HttpStatusCode.OK);
                }
                else if (stripeEvent.Type == Events.ChargeRefunded)
                {
                    var invoiceRefundModel = stripeEvent.Data.Object as Charge;
                    return new HttpResponseMessage(HttpStatusCode.OK);

                }
                else if (stripeEvent.Type == Events.CustomerSubscriptionDeleted || stripeEvent.Type == Events.SubscriptionScheduleCanceled)
                {
                    var subscriptionObj = stripeEvent.Data.Object as Subscription;

                    var subscriptionInputModel = new CompanyPaymentUpsertInputModel();
                    subscriptionInputModel.StripeCustomerId = subscriptionObj.CustomerId;
                    subscriptionInputModel.Status = subscriptionObj.Status;
                    subscriptionInputModel.IsCancelled = true;
                    subscriptionInputModel.CancelledDate = subscriptionObj.CanceledAt;
                    subscriptionInputModel.EndTime = subscriptionObj.CurrentPeriodEnd;
                    subscriptionInputModel.StartTime = subscriptionObj.CurrentPeriodStart;
                    subscriptionInputModel.SubscriptionId = subscriptionObj.Id;
                    var paymentId = _paymentService.CancelSubscription(subscriptionInputModel);
                    
                    var payment = _paymentService.GetPaymentDetailsWithSubscriptionId(subscriptionObj.Id, validationMessages);
                    if (payment != null)
                    {
                        subscriptionInputModel.CompanyId = payment.CompanyId;
                        subscriptionInputModel.NoOfPurchases = payment.Noofpurchasedlicences;
                        subscriptionInputModel.TotalAmount = payment.TotalAmountPaid;
                        subscriptionInputModel.SubscriptionType = payment.SubscriptionType;
                        subscriptionInputModel.PlanName = payment.PurchaseType;
                        var paymentReturnId = SaveCompanyPaymentDetails(subscriptionInputModel, validationMessages);
                    }
                    return new HttpResponseMessage(HttpStatusCode.OK);
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "StripeWebHookApi", "Payment api controller", exception.Message), exception);
                return new HttpResponseMessage(HttpStatusCode.BadRequest);
            }

            return new HttpResponseMessage(HttpStatusCode.OK);
        }
        private Guid? SaveCompanyPaymentDetails(CompanyPaymentUpsertInputModel companyPaymentUpsertInputModel, List<ValidationMessage> validationMessages)
        {
            Guid? companyPaymentIdReturned = null;
            var ah = Request.Headers.Authorization;
            if (ah != null && ah.Scheme.ToLower() == "bearer")
            {
                var jwtToken = ah.Parameter;

                var decodeJwt = jwtToken != "null" ? _userAuthTokenFactory.DecodeUserAuthToken(jwtToken) : null;
                if (decodeJwt != null)
                {
                    var loggedInUserId = decodeJwt.UserId;
                    companyPaymentIdReturned = _paymentService.UpsertCompanyPayment(companyPaymentUpsertInputModel, loggedInUserId, validationMessages);
                }
                else
                    companyPaymentIdReturned = _paymentService.UpsertCompanyPayment(companyPaymentUpsertInputModel, null, validationMessages);
            }
            else
            {
                companyPaymentIdReturned = _paymentService.UpsertCompanyPayment(companyPaymentUpsertInputModel, null, validationMessages);
            }
            return companyPaymentIdReturned;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdatePayment)]
        public JsonResult<BtrakJsonResult> UpdatePayment(PaymentInputModel paymentInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdatePayment", "Call Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;
             
                object outcomes = _paymentService.UpdateCRMPayment(paymentInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdatePayment", "Call Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdatePayment", "Call Api"));
                return Json(new BtrakJsonResult { Data = outcomes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdatePayment", "CallApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
