//
//  LocalizationKey.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapBundleLocalization.LocalizationKey

internal extension LocalizationKey {
	
	// MARK: - Internal -
	// MARK: Common
	
	static let common_edit		= LocalizationKey("common_edit")
	static let common_cancel	= LocalizationKey("common_cancel")
	
	// MARK: Pay Button Titles
	
    static let btn_pay_title_generic	= LocalizationKey("btn_pay_title_generic")
    static let btn_pay_title_amount		= LocalizationKey("btn_pay_title_amount")
	
	// MARK: Save Button Title
	
	static let btn_save_title			= LocalizationKey("btn_save_title")
	static let btn_save_action_title	= LocalizationKey("btn_save_action_title")
    
    // MARK: Async Button Title
    
    static let btn_async_title            = LocalizationKey("btn_async_title")
	
	// MARK: Payment Option Group Titles
	
	static let payment_options_group_title_recent = LocalizationKey("payment_options_group_title_recent")
	static let payment_options_group_title_others = LocalizationKey("payment_options_group_title_others")
	
	// MARK: Card Input Fields Placeholders
	
	static let card_input_card_number_placeholder		= LocalizationKey("card_input_card_number_placeholder")
	static let card_input_expiration_date_placeholder	= LocalizationKey("card_input_expiration_date_placeholder")
	static let card_input_cvv_placeholder				= LocalizationKey("card_input_cvv_placeholder")
	static let card_input_cardholder_name_placeholder	= LocalizationKey("card_input_cardholder_name_placeholder")
	static let card_input_address_on_card_placeholder	= LocalizationKey("card_input_address_on_card_placeholder")
	
	// MARK: Save Card Placeholders
	
	static let save_card_promotion_text			= LocalizationKey("save_card_promotion_text")
	static let saved_cards_usage_description	= LocalizationKey("saved_cards_usage_description")
	
	// MARK: Screen Titles
	
	static let currency_selection_screen_title		= LocalizationKey("currency_selection_screen_title")
	static let card_scanning_screen_title			= LocalizationKey("card_scanning_screen_title")
	static let payment_screen_title_payment			= LocalizationKey("payment_screen_title_payment")
	static let payment_screen_title_card_saving		= LocalizationKey("payment_screen_title_card_saving")
	
	// MARK: Search Bar
	
	static let search_bar_placeholder = LocalizationKey("search_bar_placeholder")
	
	// MARK: OTP Screen
	
	static let otp_guide_text		= LocalizationKey("otp_guide_text")
	static let btn_confirm_title	= LocalizationKey("btn_confirm_title")
	static let btn_resend_title		= LocalizationKey("btn_resend_title")
    
    
    // MARK: Async Screen
    
    static let async_status_text            = LocalizationKey("async_status_text")
    static let async_pay_reference_text     = LocalizationKey("async_pay_reference_text")
    static let async_pay_order_code_text    = LocalizationKey("async_pay_order_code_text")
    static let async_pay_code_expire_text   = LocalizationKey("async_pay_code_expire_text")
    static let async_pay_hint_footer_text   = LocalizationKey("async_pay_hint_footer_text")
    static let async_pay_email_text         = LocalizationKey("async_pay_email_text")
    static let async_pay_sms_text           = LocalizationKey("async_pay_sms_text")
    
	
	
	// MARK: -
	// MARK: Alert: Delete Card
	
	static let alert_delete_card_title 				= LocalizationKey("alert_delete_card_title")
	static let alert_delete_card_message 			= LocalizationKey("alert_delete_card_message")
	static let alert_delete_card_btn_cancel_title	= LocalizationKey("alert_delete_card_btn_cancel_title")
	static let alert_delete_card_btn_delete_title	= LocalizationKey("alert_delete_card_btn_delete_title")
	
	// MARK: Alert: Extra Charges
	
	static let alert_extra_charges_title 				= LocalizationKey("alert_extra_charges_title")
	static let alert_extra_charges_message 				= LocalizationKey("alert_extra_charges_message")
	static let alert_extra_charges_btn_cancel_title 	= LocalizationKey("alert_extra_charges_btn_cancel_title")
	static let alert_extra_charges_btn_confirm_title	= LocalizationKey("alert_extra_charges_btn_confirm_title")
    
    
    // MARK: Alert: Un supported card type
    
    static let alert_un_supported_card_title                 = LocalizationKey("alert_un_supported_card_title")
    static let alert_un_supported_card_message                 = LocalizationKey("alert_un_supported_card_message")
    static let alert_un_supported_card_btn_confirm_title    = LocalizationKey("alert_un_supported_card_btn_confirm_title")
	
	// MARK: Alert: Cancel Payment (status undefined)
	
	static let alert_cancel_payment_status_undefined_title				= LocalizationKey("alert_cancel_payment_status_undefined_title")
	static let alert_cancel_payment_status_undefined_message			= LocalizationKey("alert_cancel_payment_status_undefined_message")
	static let alert_cancel_payment_status_undefined_btn_no_title		= LocalizationKey("alert_cancel_payment_status_undefined_btn_no_title")
	static let alert_cancel_payment_status_undefined_btn_confirm_title	= LocalizationKey("alert_cancel_payment_status_undefined_btn_confirm_title")
	
	// MARK: Alert: Cancel Payment (just cancel)
	
	static let alert_cancel_payment_title 				= LocalizationKey("alert_cancel_payment_title")
	static let alert_cancel_payment_message 			= LocalizationKey("alert_cancel_payment_message")
	static let alert_cancel_payment_btn_no_title 		= LocalizationKey("alert_cancel_payment_btn_no_title")
	static let alert_cancel_payment_btn_confirm_title	= LocalizationKey("alert_cancel_payment_btn_confirm_title")
	
	// MARK: Alert: Error
	
	static let alert_error_1103_message 	= LocalizationKey("alert_error_1103_message")
	static let alert_error_1103_title 		= LocalizationKey("alert_error_1103_title")
	
	static let alert_error_1104_message 	= LocalizationKey("alert_error_1104_message")
	static let alert_error_1104_title 		= LocalizationKey("alert_error_1104_title")
	
	static let alert_error_1108_message 	= LocalizationKey("alert_error_1108_message")
	static let alert_error_1108_title 		= LocalizationKey("alert_error_1108_title")
	
	static let alert_error_1109_message 	= LocalizationKey("alert_error_1109_message")
	static let alert_error_1109_title 		= LocalizationKey("alert_error_1109_title")
	
	static let alert_error_1112_message 	= LocalizationKey("alert_error_1112_message")
	static let alert_error_1112_title 		= LocalizationKey("alert_error_1112_title")
	
	static let alert_error_1113_message 	= LocalizationKey("alert_error_1113_message")
	static let alert_error_1113_title 		= LocalizationKey("alert_error_1113_title")
	
	static let alert_error_1114_message 	= LocalizationKey("alert_error_1114_message")
	static let alert_error_1114_title 		= LocalizationKey("alert_error_1114_title")
	
	static let alert_error_1115_message 	= LocalizationKey("alert_error_1115_message")
	static let alert_error_1115_title 		= LocalizationKey("alert_error_1115_title")
	
	static let alert_error_1116_message 	= LocalizationKey("alert_error_1116_message")
	static let alert_error_1116_title 		= LocalizationKey("alert_error_1116_title")
	
	static let alert_error_1117_message 	= LocalizationKey("alert_error_1117_message")
	static let alert_error_1117_title 		= LocalizationKey("alert_error_1117_title")
	
	static let alert_error_1118_message 	= LocalizationKey("alert_error_1118_message")
	static let alert_error_1118_title 		= LocalizationKey("alert_error_1118_title")
	
	static let alert_error_1119_message 	= LocalizationKey("alert_error_1119_message")
	static let alert_error_1119_title 		= LocalizationKey("alert_error_1119_title")
	
	static let alert_error_1126_message 	= LocalizationKey("alert_error_1126_message")
	static let alert_error_1126_title 		= LocalizationKey("alert_error_1126_title")
	
	static let alert_error_1129_message 	= LocalizationKey("alert_error_1129_message")
	static let alert_error_1129_title 		= LocalizationKey("alert_error_1129_title")
	
	static let alert_error_1130_message 	= LocalizationKey("alert_error_1130_message")
	static let alert_error_1130_title 		= LocalizationKey("alert_error_1130_title")
	
	static let alert_error_1131_message 	= LocalizationKey("alert_error_1131_message")
	static let alert_error_1131_title 		= LocalizationKey("alert_error_1131_title")
	
	static let alert_error_1132_message 	= LocalizationKey("alert_error_1132_message")
	static let alert_error_1132_title 		= LocalizationKey("alert_error_1132_title")
	
	static let alert_error_1133_message 	= LocalizationKey("alert_error_1133_message")
	static let alert_error_1133_title 		= LocalizationKey("alert_error_1133_title")
	
	static let alert_error_1134_message 	= LocalizationKey("alert_error_1134_message")
	static let alert_error_1134_title 		= LocalizationKey("alert_error_1134_title")
	
	static let alert_error_1135_message 	= LocalizationKey("alert_error_1135_message")
	static let alert_error_1135_title 		= LocalizationKey("alert_error_1135_title")
	
	static let alert_error_1136_message 	= LocalizationKey("alert_error_1136_message")
	static let alert_error_1136_title 		= LocalizationKey("alert_error_1136_title")
	
	static let alert_error_1137_message 	= LocalizationKey("alert_error_1137_message")
	static let alert_error_1137_title 		= LocalizationKey("alert_error_1137_title")
	
	static let alert_error_1138_message 	= LocalizationKey("alert_error_1138_message")
	static let alert_error_1138_title 		= LocalizationKey("alert_error_1138_title")
	
	static let alert_error_1139_message 	= LocalizationKey("alert_error_1139_message")
	static let alert_error_1139_title 		= LocalizationKey("alert_error_1139_title")
	
	static let alert_error_1140_message 	= LocalizationKey("alert_error_1140_message")
	static let alert_error_1140_title 		= LocalizationKey("alert_error_1140_title")
	
	static let alert_error_1141_message 	= LocalizationKey("alert_error_1141_message")
	static let alert_error_1141_title 		= LocalizationKey("alert_error_1141_title")
	
	static let alert_error_1142_message 	= LocalizationKey("alert_error_1142_message")
	static let alert_error_1142_title 		= LocalizationKey("alert_error_1142_title")
	
	static let alert_error_1143_message 	= LocalizationKey("alert_error_1143_message")
	static let alert_error_1143_title 		= LocalizationKey("alert_error_1143_title")
	
	static let alert_error_1144_message 	= LocalizationKey("alert_error_1144_message")
	static let alert_error_1144_title 		= LocalizationKey("alert_error_1144_title")
	
	static let alert_error_1145_message 	= LocalizationKey("alert_error_1145_message")
	static let alert_error_1145_title 		= LocalizationKey("alert_error_1145_title")
	
	static let alert_error_1146_message 	= LocalizationKey("alert_error_1146_message")
	static let alert_error_1146_title 		= LocalizationKey("alert_error_1146_title")
	
	static let alert_error_1147_message 	= LocalizationKey("alert_error_1147_message")
	static let alert_error_1147_title 		= LocalizationKey("alert_error_1147_title")
	
	static let alert_error_1148_message 	= LocalizationKey("alert_error_1148_message")
	static let alert_error_1148_title 		= LocalizationKey("alert_error_1148_title")
	
	static let alert_error_1149_message 	= LocalizationKey("alert_error_1149_message")
	static let alert_error_1149_title 		= LocalizationKey("alert_error_1149_title")
	
	static let alert_error_1150_message 	= LocalizationKey("alert_error_1150_message")
	static let alert_error_1150_title 		= LocalizationKey("alert_error_1150_title")
	
	static let alert_error_1151_message 	= LocalizationKey("alert_error_1151_message")
	static let alert_error_1151_title 		= LocalizationKey("alert_error_1151_title")
	
	static let alert_error_1152_message 	= LocalizationKey("alert_error_1152_message")
	static let alert_error_1152_title 		= LocalizationKey("alert_error_1152_title")
	
	static let alert_error_1153_message 	= LocalizationKey("alert_error_1153_message")
	static let alert_error_1153_title 		= LocalizationKey("alert_error_1153_title")
	
	static let alert_error_2101_message 	= LocalizationKey("alert_error_2101_message")
	static let alert_error_2101_title 		= LocalizationKey("alert_error_2101_title")
	
	static let alert_error_2102_message 	= LocalizationKey("alert_error_2102_message")
	static let alert_error_2102_title 		= LocalizationKey("alert_error_2102_title")
	
	static let alert_error_2104_message 	= LocalizationKey("alert_error_2104_message")
	static let alert_error_2104_title 		= LocalizationKey("alert_error_2104_title")
	
	static let alert_error_2105_message 	= LocalizationKey("alert_error_2105_message")
	static let alert_error_2105_title 		= LocalizationKey("alert_error_2105_title")
	
	static let alert_error_2106_message 	= LocalizationKey("alert_error_2106_message")
	static let alert_error_2106_title 		= LocalizationKey("alert_error_2106_title")
	
	static let alert_error_3100_message 	= LocalizationKey("alert_error_3100_message")
	static let alert_error_3100_title 		= LocalizationKey("alert_error_3100_title")
	
	static let alert_error_8000_message 	= LocalizationKey("alert_error_8000_message")
	static let alert_error_8000_title 		= LocalizationKey("alert_error_8000_title")
	
	static let alert_error_8001_message 	= LocalizationKey("alert_error_8001_message")
	static let alert_error_8001_title 		= LocalizationKey("alert_error_8001_title")
	
	static let alert_error_8002_message 	= LocalizationKey("alert_error_8002_message")
	static let alert_error_8002_title 		= LocalizationKey("alert_error_8002_title")
	
	static let alert_error_8003_message 	= LocalizationKey("alert_error_8003_message")
	static let alert_error_8003_title 		= LocalizationKey("alert_error_8003_title")
	
	static let alert_error_8004_message 	= LocalizationKey("alert_error_8004_message")
	static let alert_error_8004_title 		= LocalizationKey("alert_error_8004_title")
	
	static let alert_error_8100_message 	= LocalizationKey("alert_error_8100_message")
	static let alert_error_8100_title 		= LocalizationKey("alert_error_8100_title")
	
	static let alert_error_8200_message 	= LocalizationKey("alert_error_8200_message")
	static let alert_error_8200_title 		= LocalizationKey("alert_error_8200_title")
	
	static let alert_error_8302_message		= LocalizationKey("alert_error_8302_message")
	static let alert_error_8302_title		= LocalizationKey("alert_error_8302_title")
	
	static let alert_error_8400_message		= LocalizationKey("alert_error_8400_message")
	static let alert_error_8400_title		= LocalizationKey("alert_error_8400_title")
	
	static let alert_error_8401_message		= LocalizationKey("alert_error_8401_message")
	static let alert_error_8401_title		= LocalizationKey("alert_error_8401_title")
	
	static let alert_error_8402_message		= LocalizationKey("alert_error_8402_message")
	static let alert_error_8402_title		= LocalizationKey("alert_error_8402_title")
	
	static let alert_error_8403_message		= LocalizationKey("alert_error_8403_message")
	static let alert_error_8403_title		= LocalizationKey("alert_error_8403_title")
	
	static let alert_error_9999_message		= LocalizationKey("alert_error_9999_message")
	static let alert_error_9999_title 		= LocalizationKey("alert_error_9999_title")
	
	static let alert_error_btn_retry_title		= LocalizationKey("alert_error_btn_retry_title")
	static let alert_error_btn_dismiss_title	= LocalizationKey("alert_error_btn_dismiss_title")
	static let alert_error_btn_report_title		= LocalizationKey("alert_error_btn_report_title")
	
	// MARK: Payment Statuses
	
	static let payment_status_initiated		= LocalizationKey("payment_status_initiated")
	static let payment_status_in_progress	= LocalizationKey("payment_status_in_progress")
	static let payment_status_abandoned		= LocalizationKey("payment_status_abandoned")
	static let payment_status_cancelled		= LocalizationKey("payment_status_cancelled")
	static let payment_status_failed		= LocalizationKey("payment_status_failed")
	static let payment_status_declined		= LocalizationKey("payment_status_declined")
	static let payment_status_restricted	= LocalizationKey("payment_status_restricted")
	static let payment_status_captured		= LocalizationKey("payment_status_captured")
	static let payment_status_authorized	= LocalizationKey("payment_status_authorized")
	static let payment_status_unknown		= LocalizationKey("payment_status_unknown")
	static let payment_status_void			= LocalizationKey("payment_status_void")
	
	static let payment_status_alert_successful	= LocalizationKey("payment_status_alert_successful")
	static let payment_status_alert_failed		= LocalizationKey("payment_status_alert_failed")
}
