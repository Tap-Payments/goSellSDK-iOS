//
//  LocalizationManager.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapBundleLocalization.LocalizationKey
import class	TapBundleLocalization.LocalizationProvider
import class	TapResponderChainInputView.TapResponderChainInputView
import enum		UIKit.UIInterface.UIUserInterfaceLayoutDirection

/// Localization provider.
internal final class LocalizationManager {
	let jsonLocalisation = "{ \"en\": { \"common_edit\": \"Edit\", \"common_cancel\": \"Cancel\", \"btn_pay_title_generic\": \"PAY\", \"btn_pay_title_amount\": \"PAY %@\", \"btn_save_title\": \"SAVE CARD\", \"btn_save_action_title\": \"SAVE\", \"btn_async_title\": \"CLOSE\", \"payment_options_group_title_recent\": \"RECENT\", \"payment_options_group_title_others\": \"OTHERS\", \"card_input_card_number_placeholder\": \"Card Number\", \"card_input_expiration_date_placeholder\": \"MM/YY\", \"card_input_cvv_placeholder\": \"CVV\", \"card_input_cardholder_name_placeholder\": \"Name On Card\", \"card_input_address_on_card_placeholder\": \"Address on Card\", \"save_card_promotion_text\": \"For faster and more secure checkout, please save your card\", \"saved_cards_usage_description\": \"Saved cards will only be used with your approval, you can remove them at any time\", \"currency_selection_screen_title\": \"Select Currency\", \"card_scanning_screen_title\": \"Scanning Card\", \"payment_screen_title_payment\": \"Checkout\", \"payment_screen_title_card_saving\": \"Enter Card Details\", \"search_bar_placeholder\": \"Search\", \"otp_guide_text\": \"Please enter the OTP that has been sent to %@\", \"btn_confirm_title\": \"CONFIRM\", \"btn_resend_title\": \"RESEND\", \"async_status_text\": \"Payment in progress\", \"async_pay_reference_text\": \"With your Fawry Pay Reference\", \"async_pay_sms_text\": \"An sms has been sent to\", \"async_pay_email_text\": \"An email has been sent to\", \"async_pay_order_code_text\": \"Order Code\", \"async_pay_code_expire_text\": \"Code Expires on\\n%@\", \"async_pay_hint_footer_text\": \"Please visit a Fawry Cash Location\\nusing the link below to complete your payment\", \"alert_delete_card_title\": \"Delete Card\", \"alert_delete_card_message\": \"Are you sure you would like to delete card %@?\", \"alert_delete_card_btn_cancel_title\": \"Cancel\", \"alert_delete_card_btn_delete_title\": \"Delete\", \"alert_extra_charges_title\": \"Confirm Extra Charges\", \"alert_extra_charges_message\": \"You will be charged an additional fee of %@ for this type of payment, totalling an amount of %@\", \"alert_extra_charges_btn_cancel_title\": \"Cancel\", \"alert_extra_charges_btn_confirm_title\": \"Confirm\", \"alert_un_supported_card_title\": \"Opps\", \"alert_un_supported_card_message\": \"Card type is not supported\", \"alert_un_supported_card_btn_confirm_title\": \"Cancel\", \"alert_cancel_payment_status_undefined_title\": \"Cancel Payment\", \"alert_cancel_payment_status_undefined_message\": \"Would you like to cancel payment? Payment status will be undefined.\", \"alert_cancel_payment_status_undefined_btn_no_title\": \"No\", \"alert_cancel_payment_status_undefined_btn_confirm_title\": \"Confirm\", \"alert_cancel_payment_title\": \"Cancel Payment\", \"alert_cancel_payment_message\": \"Would you like to cancel payment?\", \"alert_cancel_payment_btn_no_title\": \"No\", \"alert_cancel_payment_btn_confirm_title\": \"Confirm\", \"alert_error_1103_message\": \"Required inputs are invalid.\", \"alert_error_1103_title\": \"Invalid Input\", \"alert_error_1104_message\": \"Customer ID is missing.\", \"alert_error_1104_title\": \"Missing Customer ID\", \"alert_error_1108_message\": \"Save card feature is disabled.\", \"alert_error_1108_title\": \"Save Card\", \"alert_error_1109_message\": \"Non-3D secure transactions are forbidden.\", \"alert_error_1109_title\": \"3D Secure\", \"alert_error_1112_message\": \"Authorize ID is missing.\", \"alert_error_1112_title\": \"Authorize ID\", \"alert_error_1113_message\": \"Authorize ID is invalid.\", \"alert_error_1113_title\": \"Authorize ID\", \"alert_error_1114_message\": \"Please check authorize status.\", \"alert_error_1114_title\": \"Authorize Status\", \"alert_error_1115_message\": \"Authorize ID not found.\", \"alert_error_1115_title\": \"Authorize ID\", \"alert_error_1116_message\": \"Save card feature is not supported.\", \"alert_error_1116_title\": \"Save Card\", \"alert_error_1117_message\": \"Amount is invalid.\", \"alert_error_1117_title\": \"Amount\", \"alert_error_1118_message\": \"Invalid currency.\", \"alert_error_1118_title\": \"Currency\", \"alert_error_1119_message\": \"Unsupported currency.\", \"alert_error_1119_title\": \"Currency\", \"alert_error_1126_message\": \"Source is already used.\", \"alert_error_1126_title\": \"Source Used\", \"alert_error_1129_message\": \"Customer ID or customer information is required.\", \"alert_error_1129_title\": \"Customer Information\", \"alert_error_1130_message\": \"Customer first name is missing.\", \"alert_error_1130_title\": \"First Name\", \"alert_error_1131_message\": \"Customer first name is invalid.\", \"alert_error_1131_title\": \"First Name\", \"alert_error_1132_message\": \"Customer last name is missing.\", \"alert_error_1132_title\": \"Last Name\", \"alert_error_1133_message\": \"Customer last name is invalid.\", \"alert_error_1133_title\": \"Last Name\", \"alert_error_1134_message\": \"Customer middle name is invalid.\", \"alert_error_1134_title\": \"Middle Name\", \"alert_error_1135_message\": \"Phone number is missing.\", \"alert_error_1135_title\": \"Phone Number\", \"alert_error_1136_message\": \"Phone number country code is invalid.\", \"alert_error_1136_title\": \"Phone Number\", \"alert_error_1137_message\": \"Phone number is invalid.\", \"alert_error_1137_title\": \"Phone Number\", \"alert_error_1138_message\": \"Email address is invalid.\", \"alert_error_1138_title\": \"Email Address\", \"alert_error_1139_message\": \"Customer information is missing. Either email or phone number should be provided.\", \"alert_error_1139_title\": \"Customer Information\", \"alert_error_1140_message\": \"Invalid card number.\", \"alert_error_1140_title\": \"Card Number\", \"alert_error_1141_message\": \"Invalid expiration date.\", \"alert_error_1141_title\": \"Expiration Date\", \"alert_error_1142_message\": \"Charge ID is missing.\", \"alert_error_1142_title\": \"Charge ID\", \"alert_error_1143_message\": \"Charge ID is invalid.\", \"alert_error_1143_title\": \"Charge ID\", \"alert_error_1144_message\": \"Charge ID not found.\", \"alert_error_1144_title\": \"Charge ID\", \"alert_error_1145_message\": \"Authentication type is missing.\", \"alert_error_1145_title\": \"Authentication Type\", \"alert_error_1146_message\": \"Authentication type is invalid.\", \"alert_error_1146_title\": \"Authentication Type\", \"alert_error_1147_message\": \"Confirmation code is missing.\", \"alert_error_1147_title\": \"Confirmation Code\", \"alert_error_1148_message\": \"Confirmation code is invalid.\", \"alert_error_1148_title\": \"Confirmation Code\", \"alert_error_1149_message\": \"Currency code is not matching with existing currency code.\", \"alert_error_1149_title\": \"Currency Code\", \"alert_error_1150_message\": \"Capture amount exceeds with outstanding authorized amount.\", \"alert_error_1150_title\": \"Capture Amount\", \"alert_error_1151_message\": \"Gateway timed out.\", \"alert_error_1151_title\": \"Gateway Timeout\", \"alert_error_1152_message\": \"Invalid authorize auto schedule type.\", \"alert_error_1152_title\": \"Auto Schedule\", \"alert_error_1153_message\": \"Invalid authorize auto schedule time.\", \"alert_error_1153_title\": \"Auto Schedule\", \"alert_error_2101_message\": \"Server is currently unavailable. Please try again later.\", \"alert_error_2101_title\": \"Server Unavailable\", \"alert_error_2102_message\": \"Server is currently unavailable. Please try again later.\", \"alert_error_2102_title\": \"Server Unavailable\", \"alert_error_2104_message\": \"You have provided invalid API key.\", \"alert_error_2104_title\": \"API Key\", \"alert_error_2105_message\": \"API credentials are missing.\", \"alert_error_2105_title\": \"API Credentials\", \"alert_error_2106_message\": \"Public API key given. Please use secret API key instead.\", \"alert_error_2106_title\": \"API Key\", \"alert_error_3100_message\": \"Insufficient permissions.\", \"alert_error_3100_title\": \"Permission Denied\", \"alert_error_8000_message\": \"Country code is invalid.\", \"alert_error_8000_title\": \"Country Code\", \"alert_error_8001_message\": \"Amount modificator type is invalid.\", \"alert_error_8001_title\": \"Amount Modificator Type\", \"alert_error_8002_message\": \"Measurement unit is invalid.\", \"alert_error_8002_title\": \"Measurement Unit\", \"alert_error_8003_message\": \"Measurement is invalid.\", \"alert_error_8003_title\": \"Measurement\", \"alert_error_8004_message\": \"Failed to deserialize an enum.\", \"alert_error_8004_title\": \"Serialization\", \"alert_error_8100_message\": \"Serialization error has occured.\", \"alert_error_8100_title\": \"Serialization\", \"alert_error_8200_message\": \"Network error has occured.\", \"alert_error_8200_title\": \"Network\", \"alert_error_8302_message\": \"This card already exists.\", \"alert_error_8302_title\": \"Card Exists\", \"alert_error_8400_message\": \"This card is not supported.\", \"alert_error_8400_title\": \"Card Not Supported\", \"alert_error_8401_message\": \"CVV code is invalid.\", \"alert_error_8401_title\": \"CVV\", \"alert_error_8402_message\": \"Address on card is invalid.\", \"alert_error_8402_title\": \"Card Address\", \"alert_error_8403_message\": \"Cardholder name is invalid.\", \"alert_error_8403_title\": \"Cardholder Name\", \"alert_error_9999_message\": \"An unknown error has occured.\", \"alert_error_9999_title\": \"Unknown Error\", \"alert_error_btn_retry_title\": \"Retry\", \"alert_error_btn_dismiss_title\": \"Dismiss\", \"alert_error_btn_report_title\": \"Report\", \"payment_status_initiated\": \"Initiated\", \"payment_status_in_progress\": \"In Progress\", \"payment_status_abandoned\": \"Abandoned\", \"payment_status_cancelled\": \"Cancelled\", \"payment_status_failed\": \"Failed\", \"payment_status_declined\": \"Declined\", \"payment_status_restricted\": \"Restricted\", \"payment_status_captured\": \"Captured\", \"payment_status_authorized\": \"Authorized\", \"payment_status_unknown\": \"Unknown\", \"payment_status_void\": \"Void\", \"payment_status_alert_successful\": \"Successful\", \"payment_status_alert_failed\": \"Failed\" }, \"ar\": { \"common_edit\": \"تعديل\", \"common_cancel\": \"إلغاء\", \"btn_pay_title_generic\": \"ادفع\", \"btn_pay_title_amount\": \"ادفع %@\", \"btn_save_title\": \"احفظ البطاقة\", \"btn_save_action_title\": \"احفظ البطاقة\", \"btn_async_title\": \"تم\", \"payment_options_group_title_recent\": \"مستخدم حديثاً\", \"payment_options_group_title_others\": \"آخر\", \"card_input_card_number_placeholder\": \"رقم البطاقة\", \"card_input_expiration_date_placeholder\": \"شش/سس\", \"card_input_cvv_placeholder\": \"الرمز الأمني\", \"card_input_cardholder_name_placeholder\": \"الاسم الموجود على البطاقة\", \"card_input_address_on_card_placeholder\": \"عنوان الدفع\", \"save_card_promotion_text\": \"لدفع آمن و سريع، قم بحفظ بطاقتك\", \"saved_cards_usage_description\": \"البطاقات المحفوظة لن تستخدم إلا بموافقتك، يمكنك مسح معلومات البطاقات في أي وقت.\", \"currency_selection_screen_title\": \"اختر العملة\", \"card_scanning_screen_title\": \"تصوير البطاقة\", \"payment_screen_title_payment\": \"ادفع\", \"payment_screen_title_card_saving\": \"أدخل تفاصيل البطاقة\", \"search_bar_placeholder\": \"بحث\", \"otp_guide_text\": \"الرجاء إدخال الرقم المرسل إلى %@\", \"btn_confirm_title\": \"تأكيد\", \"btn_resend_title\": \"إعادة إرسال\", \"async_status_text\": \"جاري الدفع\", \"async_pay_reference_text\": \"مع كود فوري الخاص بك\", \"async_pay_ack_text\": \"تم إرسال رسالة نصية لـ\", \"async_pay_email_text\": \"تم إرسال بريد إلكتروني لـ\", \"async_pay_order_code_text\": \"كود الطلب\", \"async_pay_code_expire_text\": \"ينتهي الكود في\\n\", \"async_pay_hint_footer_text\": \"برجاء زيارة أقرب فرع فوري\\nالموجود في الرابط ادناه لاستكمال عملية الدفع\", \"alert_delete_card_title\": \"حذف البطاقة\", \"alert_delete_card_message\": \"هل أنت متأكد من حذف البطاقة %@?\", \"alert_delete_card_btn_cancel_title\": \"إلغاء\", \"alert_delete_card_btn_delete_title\": \"حذف\", \"alert_extra_charges_title\": \"تأكيد الرسوم الإضافية\", \"alert_extra_charges_message\": \"سوف تتم إضافة %@ لهذا النوع العملية، إجمالي المبلغ المطلوب %@\", \"alert_extra_charges_btn_cancel_title\": \"إلغاء\", \"alert_extra_charges_btn_confirm_title\": \"تأكيد\", \"alert_un_supported_card_title\": \"تنبيه\", \"alert_un_supported_card_message\": \"نوع البطاقة غير مدعوم\", \"alert_un_supported_card_btn_confirm_title\": \"إلغاء\", \"alert_cancel_payment_status_undefined_title\": \"إلغاء عملية الدفع\", \"alert_cancel_payment_status_undefined_message\": \"هل تود إلغاء عملية الدفع؟ حالة العملية ستصبح غير معرّفة\", \"alert_cancel_payment_status_undefined_btn_no_title\": \"لا\", \"alert_cancel_payment_status_undefined_btn_confirm_title\": \"تأكيد\", \"alert_cancel_payment_title\": \"إلغاء عملية الدفع\", \"alert_cancel_payment_message\": \"هل تود إلغاء عملية الدفع؟\", \"alert_cancel_payment_btn_no_title\": \"لا\", \"alert_cancel_payment_btn_confirm_title\": \"تأكيد\", \"alert_error_1103_message\": \"Required inputs are invalid.\", \"alert_error_1103_title\": \"Invalid Input\", \"alert_error_1104_message\": \"Customer ID is missing.\", \"alert_error_1104_title\": \"Missing Customer ID\", \"alert_error_1108_message\": \"Save card feature is disabled.\", \"alert_error_1108_title\": \"Save Card\", \"alert_error_1109_message\": \"Non-3D secure transactions are forbidden.\", \"alert_error_1109_title\": \"3D Secure\", \"alert_error_1112_message\": \"Authorize ID is missing.\", \"alert_error_1112_title\": \"Authorize ID\", \"alert_error_1113_message\": \"Authorize ID is invalid.\", \"alert_error_1113_title\": \"Authorize ID\", \"alert_error_1114_message\": \"Please check authorize status.\", \"alert_error_1114_title\": \"Authorize Status\", \"alert_error_1115_message\": \"Authorize ID not found.\", \"alert_error_1115_title\": \"Authorize ID\", \"alert_error_1116_message\": \"Save card feature is not supported.\", \"alert_error_1116_title\": \"Save Card\", \"alert_error_1117_message\": \"Amount is invalid.\", \"alert_error_1117_title\": \"Amount\", \"alert_error_1118_message\": \"Invalid currency.\", \"alert_error_1118_title\": \"Currency\", \"alert_error_1119_message\": \"Unsupported currency.\", \"alert_error_1119_title\": \"Currency\", \"alert_error_1126_message\": \"Source is already used.\", \"alert_error_1126_title\": \"Source Used\", \"alert_error_1129_message\": \"Customer ID or customer information is required.\", \"alert_error_1129_title\": \"Customer Information\", \"alert_error_1130_message\": \"Customer first name is missing.\", \"alert_error_1130_title\": \"First Name\", \"alert_error_1131_message\": \"Customer first name is invalid.\", \"alert_error_1131_title\": \"First Name\", \"alert_error_1132_message\": \"Customer last name is missing.\", \"alert_error_1132_title\": \"Last Name\", \"alert_error_1133_message\": \"Customer last name is invalid.\", \"alert_error_1133_title\": \"Last Name\", \"alert_error_1134_message\": \"Customer middle name is invalid.\", \"alert_error_1134_title\": \"Middle Name\", \"alert_error_1135_message\": \"Phone number is missing.\", \"alert_error_1135_title\": \"Phone Number\", \"alert_error_1136_message\": \"Phone number country code is invalid.\", \"alert_error_1136_title\": \"Phone Number\", \"alert_error_1137_message\": \"Phone number is invalid.\", \"alert_error_1137_title\": \"Phone Number\", \"alert_error_1138_message\": \"Email address is invalid.\", \"alert_error_1138_title\": \"Email Address\", \"alert_error_1139_message\": \"Customer information is missing. Either email or phone number should be provided.\", \"alert_error_1139_title\": \"Customer Information\", \"alert_error_1140_message\": \"Invalid card number.\", \"alert_error_1140_title\": \"Card Number\", \"alert_error_1141_message\": \"Invalid expiration date.\", \"alert_error_1141_title\": \"Expiration Date\", \"alert_error_1142_message\": \"Charge ID is missing.\", \"alert_error_1142_title\": \"Charge ID\", \"alert_error_1143_message\": \"Charge ID is invalid.\", \"alert_error_1143_title\": \"Charge ID\", \"alert_error_1144_message\": \"Charge ID not found.\", \"alert_error_1144_title\": \"Charge ID\", \"alert_error_1145_message\": \"Authentication type is missing.\", \"alert_error_1145_title\": \"Authentication Type\", \"alert_error_1146_message\": \"Authentication type is invalid.\", \"alert_error_1146_title\": \"Authentication Type\", \"alert_error_1147_message\": \"Confirmation code is missing.\", \"alert_error_1147_title\": \"Confirmation Code\", \"alert_error_1148_message\": \"Confirmation code is invalid.\", \"alert_error_1148_title\": \"Confirmation Code\", \"alert_error_1149_message\": \"Currency code is not matching with existing currency code.\", \"alert_error_1149_title\": \"Currency Code\", \"alert_error_1150_message\": \"Capture amount exceeds with outstanding authorized amount.\", \"alert_error_1150_title\": \"Capture Amount\", \"alert_error_1151_message\": \"Gateway timed out.\", \"alert_error_1151_title\": \"Gateway Timeout\", \"alert_error_1152_message\": \"Invalid authorize auto schedule type.\", \"alert_error_1152_title\": \"Auto Schedule\", \"alert_error_1153_message\": \"Invalid authorize auto schedule time.\", \"alert_error_1153_title\": \"Auto Schedule\", \"alert_error_2101_message\": \"Server is currently unavailable. Please try again later.\", \"alert_error_2101_title\": \"Server Unavailable\", \"alert_error_2102_message\": \"Server is currently unavailable. Please try again later.\", \"alert_error_2102_title\": \"Server Unavailable\", \"alert_error_2104_message\": \"You have provided invalid API key.\", \"alert_error_2104_title\": \"API Key\", \"alert_error_2105_message\": \"API credentials are missing.\", \"alert_error_2105_title\": \"API Credentials\", \"alert_error_2106_message\": \"Public API key given. Please use secret API key instead.\", \"alert_error_2106_title\": \"API Key\", \"alert_error_3100_message\": \"Insufficient permissions.\", \"alert_error_3100_title\": \"Permission Denied\", \"alert_error_8000_message\": \"Country code is invalid.\", \"alert_error_8000_title\": \"Country Code\", \"alert_error_8001_message\": \"Amount modificator type is invalid.\", \"alert_error_8001_title\": \"Amount Modificator Type\", \"alert_error_8002_message\": \"Measurement unit is invalid.\", \"alert_error_8002_title\": \"Measurement Unit\", \"alert_error_8003_message\": \"Measurement is invalid.\", \"alert_error_8003_title\": \"Measurement\", \"alert_error_8004_message\": \"Failed to deserialize an enum.\", \"alert_error_8004_title\": \"Serialization\", \"alert_error_8100_message\": \"Serialization error has occured.\", \"alert_error_8100_title\": \"Serialization\", \"alert_error_8200_message\": \"Network error has occured.\", \"alert_error_8200_title\": \"Network\", \"alert_error_8302_message\": \"This card already exists.\", \"alert_error_8302_title\": \"Card Exists\", \"alert_error_8400_message\": \"This card is not supported.\", \"alert_error_8400_title\": \"Card Not Supported\", \"alert_error_8401_message\": \"CVV code is invalid.\", \"alert_error_8401_title\": \"CVV\", \"alert_error_8402_message\": \"Address on card is invalid.\", \"alert_error_8402_title\": \"Card Address\", \"alert_error_8403_message\": \"Cardholder name is invalid.\", \"alert_error_8403_title\": \"Cardholder Name\", \"alert_error_9999_message\": \"An unknown error has occured.\", \"alert_error_9999_title\": \"Unknown Error\", \"alert_error_btn_retry_title\": \"Retry\", \"alert_error_btn_dismiss_title\": \"Dismiss\", \"alert_error_btn_report_title\": \"Report\", \"payment_status_initiated\": \"Initiated\", \"payment_status_in_progress\": \"In Progress\", \"payment_status_abandoned\": \"Abandoned\", \"payment_status_cancelled\": \"Cancelled\", \"payment_status_failed\": \"Failed\", \"payment_status_declined\": \"Declined\", \"payment_status_restricted\": \"Restricted\", \"payment_status_captured\": \"Captured\", \"payment_status_authorized\": \"Authorized\", \"payment_status_unknown\": \"Unknown\", \"payment_status_void\": \"Void\", \"payment_status_alert_successful\": \"تم اتمام العملية بنجاح\", \"payment_status_alert_failed\": \"فشل عملية الدفع\" }, \"ru\": { \"common_edit\": \"Изменить\", \"common_cancel\": \"Отмена\", \"btn_pay_title_generic\": \"ОПЛАТИТЬ\", \"btn_pay_title_amount\": \"ОПЛАТИТЬ %@\", \"btn_save_title\": \"СОХРАНИТЬ КАРТУ\", \"btn_save_action_title\": \"СОХРАНИТЬ\", \"payment_options_group_title_recent\": \"НЕДАВНИЕ\", \"payment_options_group_title_others\": \"ДРУГИЕ\", \"card_input_card_number_placeholder\": \"Номер карты\", \"card_input_expiration_date_placeholder\": \"ММ/ГГ\", \"card_input_cvv_placeholder\": \"CVV\", \"card_input_cardholder_name_placeholder\": \"Имя владельца карты\", \"card_input_address_on_card_placeholder\": \"Адрес на карте\", \"save_card_promotion_text\": \"Для более быстрой и безопасной оплаты сохраните карту\", \"saved_cards_usage_description\": \"Сохранённые карты будут использоваться только с Вашего согласия, Вы можете удалить их в любое время.\", \"currency_selection_screen_title\": \"Выберите валюту\", \"card_scanning_screen_title\": \"Сканирование карты\", \"payment_screen_title_payment\": \"Оплата\", \"payment_screen_title_card_saving\": \"Введите данные карты\", \"search_bar_placeholder\": \"Поиск\", \"otp_guide_text\": \"Пожалуйста, введите код из СМС, отправленный на номер %@\", \"btn_confirm_title\": \"ПОДТВЕРДИТЬ\", \"btn_resend_title\": \"ОТПРАВИТЬ ЕЩЕ РАЗ\", \"alert_delete_card_title\": \"Удалить карту\", \"alert_delete_card_message\": \"Вы уверены, что хотите удалить карту %@?\", \"alert_delete_card_btn_cancel_title\": \"Отмена\", \"alert_delete_card_btn_delete_title\": \"Удалить\", \"alert_extra_charges_title\": \"Дополнительные сборы\", \"alert_extra_charges_message\": \"С Вас дополнительно будет взято %@ за этот способ оплаты. Всего к оплате: %@\", \"alert_extra_charges_btn_cancel_title\": \"Отмена\", \"alert_extra_charges_btn_confirm_title\": \"Подтвердить\", \"alert_cancel_payment_status_undefined_title\": \"Отменить оплату\", \"alert_cancel_payment_status_undefined_message\": \"Вы хотите отменить оплату? Статус оплаты будет неизвестен.\", \"alert_cancel_payment_status_undefined_btn_no_title\": \"Нет\", \"alert_cancel_payment_status_undefined_btn_confirm_title\": \"Подтвердить\", \"alert_cancel_payment_title\": \"Отменить оплату\", \"alert_cancel_payment_message\": \"Вы хотите отменить оплату?\", \"alert_cancel_payment_btn_no_title\": \"Нет\", \"alert_cancel_payment_btn_confirm_title\": \"Подтвердить\", \"alert_error_1103_message\": \"Required inputs are invalid.\", \"alert_error_1103_title\": \"Invalid Input\", \"alert_error_1104_message\": \"Customer ID is missing.\", \"alert_error_1104_title\": \"Missing Customer ID\", \"alert_error_1108_message\": \"Save card feature is disabled.\", \"alert_error_1108_title\": \"Save Card\", \"alert_error_1109_message\": \"Non-3D secure transactions are forbidden.\", \"alert_error_1109_title\": \"3D Secure\", \"alert_error_1112_message\": \"Authorize ID is missing.\", \"alert_error_1112_title\": \"Authorize ID\", \"alert_error_1113_message\": \"Authorize ID is invalid.\", \"alert_error_1113_title\": \"Authorize ID\", \"alert_error_1114_message\": \"Please check authorize status.\", \"alert_error_1114_title\": \"Authorize Status\", \"alert_error_1115_message\": \"Authorize ID not found.\", \"alert_error_1115_title\": \"Authorize ID\", \"alert_error_1116_message\": \"Save card feature is not supported.\", \"alert_error_1116_title\": \"Save Card\", \"alert_error_1117_message\": \"Amount is invalid.\", \"alert_error_1117_title\": \"Amount\", \"alert_error_1118_message\": \"Invalid currency.\", \"alert_error_1118_title\": \"Currency\", \"alert_error_1119_message\": \"Unsupported currency.\", \"alert_error_1119_title\": \"Currency\", \"alert_error_1126_message\": \"Source is already used.\", \"alert_error_1126_title\": \"Source Used\", \"alert_error_1129_message\": \"Customer ID or customer information is required.\", \"alert_error_1129_title\": \"Customer Information\", \"alert_error_1130_message\": \"Customer first name is missing.\", \"alert_error_1130_title\": \"First Name\", \"alert_error_1131_message\": \"Customer first name is invalid.\", \"alert_error_1131_title\": \"First Name\", \"alert_error_1132_message\": \"Customer last name is missing.\", \"alert_error_1132_title\": \"Last Name\", \"alert_error_1133_message\": \"Customer last name is invalid.\", \"alert_error_1133_title\": \"Last Name\", \"alert_error_1134_message\": \"Customer middle name is invalid.\", \"alert_error_1134_title\": \"Middle Name\", \"alert_error_1135_message\": \"Phone number is missing.\", \"alert_error_1135_title\": \"Phone Number\", \"alert_error_1136_message\": \"Phone number country code is invalid.\", \"alert_error_1136_title\": \"Phone Number\", \"alert_error_1137_message\": \"Phone number is invalid.\", \"alert_error_1137_title\": \"Phone Number\", \"alert_error_1138_message\": \"Email address is invalid.\", \"alert_error_1138_title\": \"Email Address\", \"alert_error_1139_message\": \"Customer information is missing. Either email or phone number should be provided.\", \"alert_error_1139_title\": \"Customer Information\", \"alert_error_1140_message\": \"Invalid card number.\", \"alert_error_1140_title\": \"Card Number\", \"alert_error_1141_message\": \"Invalid expiration date.\", \"alert_error_1141_title\": \"Expiration Date\", \"alert_error_1142_message\": \"Charge ID is missing.\", \"alert_error_1142_title\": \"Charge ID\", \"alert_error_1143_message\": \"Charge ID is invalid.\", \"alert_error_1143_title\": \"Charge ID\", \"alert_error_1144_message\": \"Charge ID not found.\", \"alert_error_1144_title\": \"Charge ID\", \"alert_error_1145_message\": \"Authentication type is missing.\", \"alert_error_1145_title\": \"Authentication Type\", \"alert_error_1146_message\": \"Authentication type is invalid.\", \"alert_error_1146_title\": \"Authentication Type\", \"alert_error_1147_message\": \"Confirmation code is missing.\", \"alert_error_1147_title\": \"Confirmation Code\", \"alert_error_1148_message\": \"Confirmation code is invalid.\", \"alert_error_1148_title\": \"Confirmation Code\", \"alert_error_1149_message\": \"Currency code is not matching with existing currency code.\", \"alert_error_1149_title\": \"Currency Code\", \"alert_error_1150_message\": \"Capture amount exceeds with outstanding authorized amount.\", \"alert_error_1150_title\": \"Capture Amount\", \"alert_error_1151_message\": \"Gateway timed out.\", \"alert_error_1151_title\": \"Gateway Timeout\", \"alert_error_1152_message\": \"Invalid authorize auto schedule type.\", \"alert_error_1152_title\": \"Auto Schedule\", \"alert_error_1153_message\": \"Invalid authorize auto schedule time.\", \"alert_error_1153_title\": \"Auto Schedule\", \"alert_error_2101_message\": \"Server is currently unavailable. Please try again later.\", \"alert_error_2101_title\": \"Server Unavailable\", \"alert_error_2102_message\": \"Server is currently unavailable. Please try again later.\", \"alert_error_2102_title\": \"Server Unavailable\", \"alert_error_2104_message\": \"You have provided invalid API key.\", \"alert_error_2104_title\": \"API Key\", \"alert_error_2105_message\": \"API credentials are missing.\", \"alert_error_2105_title\": \"API Credentials\", \"alert_error_2106_message\": \"Public API key given. Please use secret API key instead.\", \"alert_error_2106_title\": \"API Key\", \"alert_error_3100_message\": \"Insufficient permissions.\", \"alert_error_3100_title\": \"Permission Denied\", \"alert_error_8000_message\": \"Country code is invalid.\", \"alert_error_8000_title\": \"Country Code\", \"alert_error_8001_message\": \"Amount modificator type is invalid.\", \"alert_error_8001_title\": \"Amount Modificator Type\", \"alert_error_8002_message\": \"Measurement unit is invalid.\", \"alert_error_8002_title\": \"Measurement Unit\", \"alert_error_8003_message\": \"Measurement is invalid.\", \"alert_error_8003_title\": \"Measurement\", \"alert_error_8004_message\": \"Failed to deserialize an enum.\", \"alert_error_8004_title\": \"Serialization\", \"alert_error_8100_message\": \"Serialization error has occured.\", \"alert_error_8100_title\": \"Serialization\", \"alert_error_8200_message\": \"Network error has occured.\", \"alert_error_8200_title\": \"Network\", \"alert_error_8302_message\": \"This card already exists.\", \"alert_error_8302_title\": \"Card Exists\", \"alert_error_8400_message\": \"This card is not supported.\", \"alert_error_8400_title\": \"Card Not Supported\", \"alert_error_8401_message\": \"CVV code is invalid.\", \"alert_error_8401_title\": \"CVV\", \"alert_error_8402_message\": \"Address on card is invalid.\", \"alert_error_8402_title\": \"Card Address\", \"alert_error_8403_message\": \"Cardholder name is invalid.\", \"alert_error_8403_title\": \"Cardholder Name\", \"alert_error_9999_message\": \"An unknown error has occured.\", \"alert_error_9999_title\": \"Unknown Error\", \"alert_error_btn_retry_title\": \"Повторить\", \"alert_error_btn_dismiss_title\": \"Закрыть\", \"alert_error_btn_report_title\": \"Сообщить об ошибке\", \"payment_status_initiated\": \"Началось\", \"payment_status_in_progress\": \"В процессе\", \"payment_status_abandoned\": \"Заброшено\", \"payment_status_cancelled\": \"Отменено\", \"payment_status_failed\": \"Неуспешно\", \"payment_status_declined\": \"Отказано\", \"payment_status_restricted\": \"Ограничено\", \"payment_status_captured\": \"Захвачено\", \"payment_status_authorized\": \"Одобрено\", \"payment_status_unknown\": \"Неизвестно\", \"payment_status_void\": \"Недействительно\", \"payment_status_alert_successful\": \"Успешно\", \"payment_status_alert_failed\": \"Неуспешно\" } }"
	// MARK: - Internal -
	// MARK: Properties
	
	internal var availableLocalizations: [String] {
		
		return self.provider.availableLocalizations
	}
	
	internal var layoutDirection: UIUserInterfaceLayoutDirection {
		
		return self.provider.suggestedInterfaceLayoutDirection
	}
	
	internal var selectedLocale: Locale {
		
		return self.provider.selectedLocale
	}
	
	internal var selectedLanguage: String {
		
		get {
		
			return self.provider.selectedLanguage
		}
		set {
		
			guard self.selectedLanguage != newValue else { return }
		
			let oldValue = self.provider.selectedLanguage
			
			self.provider.selectedLanguage = newValue
			
			NotificationCenter.default.post(name: .tap_sdkLanguageChanged, object: nil)
			
			#if GOSELLSDK_ERROR_REPORTING_AVAILABLE
			
				Reporter.language = newValue
			
			#endif
			
			self.postLayoutDirectionChangeNotificationIfLayoutDirectionChanged(compareTo: oldValue)
		}
	}
	
	// MARK: Methods
	
	internal func localizedString(for key: LocalizationKey) -> String {
		
        let data:Data = Data(jsonLocalisation.utf8)
        do {
          // make sure this JSON is in the format we expect
          if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
              // try to read out a string array
            if let localisedLang:[String:Any] = json[selectedLanguage] as? [String:Any] {
                if let localisedFromString:String = localisedLang[key.rawValue] as? String {
                    return localisedFromString
                }
            }
          }
        } catch let error as NSError {
          print("Failed to load: \(error.localizedDescription)")
        }
        
        let localisedFromBundle:String = self.provider.localizedString(for: key)
           
        return localisedFromBundle
        
	}
	
	internal func localizedErrorTitle(for error: ErrorCode) -> String {
		
		guard let key = self.alertTitleKey(for: error) else {
			
			print("There is no localization error title for error \(error.rawValue). Please report this problem to developer.")
			return self.localizedString(for: .alert_error_9999_title)
		}
		
		return self.localizedString(for: key)
	}
	
	internal func localizedErrorMessage(for error: ErrorCode) -> String {
		
		guard let key = self.alertMessageKey(for: error) else {
			
			print("There is no localization error message for error \(error.rawValue). Please report this problem to developer.")
			return self.localizedString(for: .alert_error_9999_message)
		}
		
		return self.localizedString(for: key)
	}
	
	// MARK: - Private -
	
	private struct Constants {
		
		fileprivate static let localeFolderExtension = "lproj"
		
		@available(*, unavailable) private init() {}
	}
	
	// MARK: Properties
	
	private static var storage: LocalizationManager?
	
	private lazy var provider = LocalizationProvider(bundle: .goSellSDKResources)
	
	// MARK: Methods
	
	private init() {
		
		self.updateResponderChainInputViewLayoutDirection()
	}
	
	private func postLayoutDirectionChangeNotificationIfLayoutDirectionChanged(compareTo oldLanguage: String) {
		
		let oldDirection: UIUserInterfaceLayoutDirection = Locale.characterDirection(forLanguage: oldLanguage) == .rightToLeft ? .rightToLeft : .leftToRight
		if oldDirection != self.layoutDirection {
			
			NotificationCenter.default.post(name: .tap_sdkLayoutDirectionChanged, object: nil)
			
			self.updateResponderChainInputViewLayoutDirection()
		}
	}
	
	private func updateResponderChainInputViewLayoutDirection()  {
		
		TapResponderChainInputView.globalSettings.hasRTLLayout = self.layoutDirection == .rightToLeft
	}
	
	private func alertTitleKey(for error: ErrorCode) -> LocalizationKey? {
		
		let raw = "alert_error_\(error.rawValue)_title"
		return LocalizationKey(raw)
	}
	
	private func alertMessageKey(for error: ErrorCode) -> LocalizationKey? {
		
		let raw = "alert_error_\(error.rawValue)_message"
		return LocalizationKey(raw)
	}
}

// MARK: - Singleton
extension LocalizationManager: Singleton {
	
	internal static var shared: LocalizationManager {
		
		if let nonnullStorage = self.storage {
			
			return nonnullStorage
		}
		
		let result = LocalizationManager()
		self.storage = result
		
		return result
	}
}

// MARK: - StaticlyDestroyable
extension LocalizationManager: StaticlyDestroyable {
	
	internal static var hasAliveInstance: Bool {
		
		return self.storage != nil
	}
}

// MARK: - ImmediatelyDestroyable
extension LocalizationManager: ImmediatelyDestroyable {
	
	internal static func destroyInstance() {
		
		self.storage = nil
	}
}
