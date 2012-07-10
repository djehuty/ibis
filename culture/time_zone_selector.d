module culture.time_zone_selector;

import chrono.month;
import culture.zones.africa_abidjan;
import culture.zones.africa_accra;
import culture.zones.africa_addis_ababa;
import culture.zones.africa_algiers;
import culture.zones.africa_asmara;
import culture.zones.africa_bamako;
import culture.zones.africa_bangui;
import culture.zones.africa_banjul;
import culture.zones.africa_bissau;
import culture.zones.africa_blantyre;
import culture.zones.africa_brazzaville;
import culture.zones.africa_bujumbura;
import culture.zones.africa_cairo;
import culture.zones.africa_casablanca;
import culture.zones.africa_ceuta;
import culture.zones.africa_conakry;
import culture.zones.africa_dakar;
import culture.zones.africa_dar_es_salaam;
import culture.zones.africa_djibouti;
import culture.zones.africa_douala;
import culture.zones.africa_el_aaiun;
import culture.zones.africa_freetown;
import culture.zones.africa_gaborone;
import culture.zones.africa_harare;
import culture.zones.africa_johannesburg;
import culture.zones.africa_kampala;
import culture.zones.africa_khartoum;
import culture.zones.africa_kigali;
import culture.zones.africa_kinshasa;
import culture.zones.africa_lagos;
import culture.zones.africa_libreville;
import culture.zones.africa_lome;
import culture.zones.africa_luanda;
import culture.zones.africa_lubumbashi;
import culture.zones.africa_lusaka;
import culture.zones.africa_malabo;
import culture.zones.africa_maputo;
import culture.zones.africa_maseru;
import culture.zones.africa_mbabane;
import culture.zones.africa_mogadishu;
import culture.zones.africa_monrovia;
import culture.zones.africa_nairobi;
import culture.zones.africa_ndjamena;
import culture.zones.africa_niamey;
import culture.zones.africa_nouakchott;
import culture.zones.africa_ouagadougou;
import culture.zones.africa_porto_novo;
import culture.zones.africa_sao_tome;
import culture.zones.africa_tripoli;
import culture.zones.africa_tunis;
import culture.zones.africa_windhoek;
import culture.zones.america_adak;
import culture.zones.america_anchorage;
import culture.zones.america_anguilla;
import culture.zones.america_antigua;
import culture.zones.america_araguaina;
import culture.zones.america_argentina_buenos_aires;
import culture.zones.america_argentina_catamarca;
import culture.zones.america_argentina_cordoba;
import culture.zones.america_argentina_jujuy;
import culture.zones.america_argentina_la_rioja;
import culture.zones.america_argentina_mendoza;
import culture.zones.america_argentina_rio_gallegos;
import culture.zones.america_argentina_salta;
import culture.zones.america_argentina_san_juan;
import culture.zones.america_argentina_san_luis;
import culture.zones.america_argentina_tucuman;
import culture.zones.america_argentina_ushuaia;
import culture.zones.america_aruba;
import culture.zones.america_asuncion;
import culture.zones.america_atikokan;
import culture.zones.america_bahia;
import culture.zones.america_bahia_banderas;
import culture.zones.america_barbados;
import culture.zones.america_belem;
import culture.zones.america_belize;
import culture.zones.america_blanc_sablon;
import culture.zones.america_boa_vista;
import culture.zones.america_bogota;
import culture.zones.america_boise;
import culture.zones.america_cambridge_bay;
import culture.zones.america_campo_grande;
import culture.zones.america_cancun;
import culture.zones.america_caracas;
import culture.zones.america_cayenne;
import culture.zones.america_cayman;
import culture.zones.america_chicago;
import culture.zones.america_chihuahua;
import culture.zones.america_costa_rica;
import culture.zones.america_cuiaba;
import culture.zones.america_curacao;
import culture.zones.america_danmarkshavn;
import culture.zones.america_dawson;
import culture.zones.america_dawson_creek;
import culture.zones.america_denver;
import culture.zones.america_detroit;
import culture.zones.america_dominica;
import culture.zones.america_edmonton;
import culture.zones.america_eirunepe;
import culture.zones.america_el_salvador;
import culture.zones.america_fortaleza;
import culture.zones.america_glace_bay;
import culture.zones.america_godthab;
import culture.zones.america_goose_bay;
import culture.zones.america_grand_turk;
import culture.zones.america_grenada;
import culture.zones.america_guadeloupe;
import culture.zones.america_guatemala;
import culture.zones.america_guayaquil;
import culture.zones.america_guyana;
import culture.zones.america_halifax;
import culture.zones.america_havana;
import culture.zones.america_hermosillo;
import culture.zones.america_indiana_indianapolis;
import culture.zones.america_indiana_knox;
import culture.zones.america_indiana_marengo;
import culture.zones.america_indiana_petersburg;
import culture.zones.america_indiana_tell_city;
import culture.zones.america_indiana_vevay;
import culture.zones.america_indiana_vincennes;
import culture.zones.america_indiana_winamac;
import culture.zones.america_inuvik;
import culture.zones.america_iqaluit;
import culture.zones.america_jamaica;
import culture.zones.america_juneau;
import culture.zones.america_kentucky_louisville;
import culture.zones.america_kentucky_monticello;
import culture.zones.america_la_paz;
import culture.zones.america_lima;
import culture.zones.america_los_angeles;
import culture.zones.america_maceio;
import culture.zones.america_managua;
import culture.zones.america_manaus;
import culture.zones.america_martinique;
import culture.zones.america_matamoros;
import culture.zones.america_mazatlan;
import culture.zones.america_menominee;
import culture.zones.america_merida;
import culture.zones.america_metlakatla;
import culture.zones.america_mexico_city;
import culture.zones.america_miquelon;
import culture.zones.america_moncton;
import culture.zones.america_monterrey;
import culture.zones.america_montevideo;
import culture.zones.america_montreal;
import culture.zones.america_montserrat;
import culture.zones.america_nassau;
import culture.zones.america_new_york;
import culture.zones.america_nipigon;
import culture.zones.america_nome;
import culture.zones.america_noronha;
import culture.zones.america_north_dakota_beulah;
import culture.zones.america_north_dakota_center;
import culture.zones.america_north_dakota_new_salem;
import culture.zones.america_ojinaga;
import culture.zones.america_panama;
import culture.zones.america_pangnirtung;
import culture.zones.america_paramaribo;
import culture.zones.america_phoenix;
import culture.zones.america_port_au_prince;
import culture.zones.america_port_of_spain;
import culture.zones.america_porto_velho;
import culture.zones.america_puerto_rico;
import culture.zones.america_rainy_river;
import culture.zones.america_rankin_inlet;
import culture.zones.america_recife;
import culture.zones.america_regina;
import culture.zones.america_resolute;
import culture.zones.america_rio_branco;
import culture.zones.america_santa_isabel;
import culture.zones.america_santarem;
import culture.zones.america_santiago;
import culture.zones.america_santo_domingo;
import culture.zones.america_sao_paulo;
import culture.zones.america_scoresbysund;
import culture.zones.america_sitka;
import culture.zones.america_st_johns;
import culture.zones.america_st_kitts;
import culture.zones.america_st_lucia;
import culture.zones.america_st_thomas;
import culture.zones.america_st_vincent;
import culture.zones.america_swift_current;
import culture.zones.america_tegucigalpa;
import culture.zones.america_thule;
import culture.zones.america_thunder_bay;
import culture.zones.america_tijuana;
import culture.zones.america_toronto;
import culture.zones.america_tortola;
import culture.zones.america_vancouver;
import culture.zones.america_whitehorse;
import culture.zones.america_winnipeg;
import culture.zones.america_yakutat;
import culture.zones.america_yellowknife;
import culture.zones.antarctica_casey;
import culture.zones.antarctica_davis;
import culture.zones.antarctica_dumontdurville;
import culture.zones.antarctica_macquarie;
import culture.zones.antarctica_mawson;
import culture.zones.antarctica_mcmurdo;
import culture.zones.antarctica_palmer;
import culture.zones.antarctica_rothera;
import culture.zones.antarctica_syowa;
import culture.zones.antarctica_vostok;
import culture.zones.asia_aden;
import culture.zones.asia_almaty;
import culture.zones.asia_amman;
import culture.zones.asia_anadyr;
import culture.zones.asia_aqtau;
import culture.zones.asia_aqtobe;
import culture.zones.asia_ashgabat;
import culture.zones.asia_baghdad;
import culture.zones.asia_bahrain;
import culture.zones.asia_baku;
import culture.zones.asia_bangkok;
import culture.zones.asia_beirut;
import culture.zones.asia_bishkek;
import culture.zones.asia_brunei;
import culture.zones.asia_choibalsan;
import culture.zones.asia_chongqing;
import culture.zones.asia_colombo;
import culture.zones.asia_damascus;
import culture.zones.asia_dhaka;
import culture.zones.asia_dili;
import culture.zones.asia_dubai;
import culture.zones.asia_dushanbe;
import culture.zones.asia_gaza;
import culture.zones.asia_harbin;
import culture.zones.asia_ho_chi_minh;
import culture.zones.asia_hong_kong;
import culture.zones.asia_hovd;
import culture.zones.asia_irkutsk;
import culture.zones.asia_jakarta;
import culture.zones.asia_jayapura;
import culture.zones.asia_jerusalem;
import culture.zones.asia_kabul;
import culture.zones.asia_kamchatka;
import culture.zones.asia_karachi;
import culture.zones.asia_kashgar;
import culture.zones.asia_kathmandu;
import culture.zones.asia_kolkata;
import culture.zones.asia_krasnoyarsk;
import culture.zones.asia_kuala_lumpur;
import culture.zones.asia_kuching;
import culture.zones.asia_kuwait;
import culture.zones.asia_macau;
import culture.zones.asia_magadan;
import culture.zones.asia_makassar;
import culture.zones.asia_manila;
import culture.zones.asia_muscat;
import culture.zones.asia_nicosia;
import culture.zones.asia_novokuznetsk;
import culture.zones.asia_novosibirsk;
import culture.zones.asia_omsk;
import culture.zones.asia_oral;
import culture.zones.asia_phnom_penh;
import culture.zones.asia_pontianak;
import culture.zones.asia_pyongyang;
import culture.zones.asia_qatar;
import culture.zones.asia_qyzylorda;
import culture.zones.asia_rangoon;
import culture.zones.asia_riyadh;
import culture.zones.asia_sakhalin;
import culture.zones.asia_samarkand;
import culture.zones.asia_seoul;
import culture.zones.asia_shanghai;
import culture.zones.asia_singapore;
import culture.zones.asia_taipei;
import culture.zones.asia_tashkent;
import culture.zones.asia_tbilisi;
import culture.zones.asia_tehran;
import culture.zones.asia_thimphu;
import culture.zones.asia_tokyo;
import culture.zones.asia_ulaanbaatar;
import culture.zones.asia_urumqi;
import culture.zones.asia_vientiane;
import culture.zones.asia_vladivostok;
import culture.zones.asia_yakutsk;
import culture.zones.asia_yekaterinburg;
import culture.zones.asia_yerevan;
import culture.zones.atlantic_azores;
import culture.zones.atlantic_bermuda;
import culture.zones.atlantic_canary;
import culture.zones.atlantic_cape_verde;
import culture.zones.atlantic_faroe;
import culture.zones.atlantic_madeira;
import culture.zones.atlantic_reykjavik;
import culture.zones.atlantic_south_georgia;
import culture.zones.atlantic_st_helena;
import culture.zones.atlantic_stanley;
import culture.zones.australia_adelaide;
import culture.zones.australia_brisbane;
import culture.zones.australia_broken_hill;
import culture.zones.australia_currie;
import culture.zones.australia_darwin;
import culture.zones.australia_eucla;
import culture.zones.australia_hobart;
import culture.zones.australia_lindeman;
import culture.zones.australia_lord_howe;
import culture.zones.australia_melbourne;
import culture.zones.australia_perth;
import culture.zones.australia_sydney;
import culture.zones.cet;
import culture.zones.cst6cdt;
import culture.zones.eet;
import culture.zones.est;
import culture.zones.est5edt;
import culture.zones.europe_amsterdam;
import culture.zones.europe_andorra;
import culture.zones.europe_athens;
import culture.zones.europe_belgrade;
import culture.zones.europe_berlin;
import culture.zones.europe_brussels;
import culture.zones.europe_bucharest;
import culture.zones.europe_budapest;
import culture.zones.europe_chisinau;
import culture.zones.europe_copenhagen;
import culture.zones.europe_dublin;
import culture.zones.europe_gibraltar;
import culture.zones.europe_helsinki;
import culture.zones.europe_istanbul;
import culture.zones.europe_kaliningrad;
import culture.zones.europe_kiev;
import culture.zones.europe_lisbon;
import culture.zones.europe_london;
import culture.zones.europe_luxembourg;
import culture.zones.europe_madrid;
import culture.zones.europe_malta;
import culture.zones.europe_minsk;
import culture.zones.europe_monaco;
import culture.zones.europe_moscow;
import culture.zones.europe_oslo;
import culture.zones.europe_paris;
import culture.zones.europe_prague;
import culture.zones.europe_riga;
import culture.zones.europe_rome;
import culture.zones.europe_samara;
import culture.zones.europe_simferopol;
import culture.zones.europe_sofia;
import culture.zones.europe_stockholm;
import culture.zones.europe_tallinn;
import culture.zones.europe_tirane;
import culture.zones.europe_uzhgorod;
import culture.zones.europe_vaduz;
import culture.zones.europe_vienna;
import culture.zones.europe_vilnius;
import culture.zones.europe_volgograd;
import culture.zones.europe_warsaw;
import culture.zones.europe_zaporozhye;
import culture.zones.europe_zurich;
import culture.zones.hst;
import culture.zones.indian_antananarivo;
import culture.zones.indian_chagos;
import culture.zones.indian_christmas;
import culture.zones.indian_cocos;
import culture.zones.indian_comoro;
import culture.zones.indian_kerguelen;
import culture.zones.indian_mahe;
import culture.zones.indian_maldives;
import culture.zones.indian_mauritius;
import culture.zones.indian_mayotte;
import culture.zones.indian_reunion;
import culture.zones.met;
import culture.zones.mst;
import culture.zones.mst7mdt;
import culture.zones.pst8pdt;
import culture.zones.pacific_apia;
import culture.zones.pacific_auckland;
import culture.zones.pacific_chatham;
import culture.zones.pacific_chuuk;
import culture.zones.pacific_easter;
import culture.zones.pacific_efate;
import culture.zones.pacific_enderbury;
import culture.zones.pacific_fakaofo;
import culture.zones.pacific_fiji;
import culture.zones.pacific_funafuti;
import culture.zones.pacific_galapagos;
import culture.zones.pacific_gambier;
import culture.zones.pacific_guadalcanal;
import culture.zones.pacific_guam;
import culture.zones.pacific_honolulu;
import culture.zones.pacific_johnston;
import culture.zones.pacific_kiritimati;
import culture.zones.pacific_kosrae;
import culture.zones.pacific_kwajalein;
import culture.zones.pacific_majuro;
import culture.zones.pacific_marquesas;
import culture.zones.pacific_midway;
import culture.zones.pacific_nauru;
import culture.zones.pacific_niue;
import culture.zones.pacific_norfolk;
import culture.zones.pacific_noumea;
import culture.zones.pacific_pago_pago;
import culture.zones.pacific_palau;
import culture.zones.pacific_pitcairn;
import culture.zones.pacific_pohnpei;
import culture.zones.pacific_port_moresby;
import culture.zones.pacific_rarotonga;
import culture.zones.pacific_saipan;
import culture.zones.pacific_tahiti;
import culture.zones.pacific_tarawa;
import culture.zones.pacific_tongatapu;
import culture.zones.pacific_wake;
import culture.zones.pacific_wallis;
import culture.zones.wet;

class TimeZoneSelector {
static:
public:
	
	bool funcs(char[] timezone,
	           ref long function(long, Month, uint, uint, uint) offset,
	           ref long function(long, Month, uint, uint, uint) savings) {
		if (timezone == "Antarctica/Vostok") {
			offset = &AntarcticaVostokZone.offset;
			savings = &AntarcticaVostokZone.savings;
			
			return true;
		}
		else if (timezone < "Antarctica/Vostok") {
			if (timezone == "America/Glace_Bay") {
				offset = &AmericaGlaceBayZone.offset;
				savings = &AmericaGlaceBayZone.savings;
				
				return true;
			}
			else if (timezone < "America/Glace_Bay") {
				if (timezone == "Africa/Windhoek") {
					offset = &AfricaWindhoekZone.offset;
					savings = &AfricaWindhoekZone.savings;
					
					return true;
				}
				else if (timezone < "Africa/Windhoek") {
					if (timezone == "Africa/Kampala") {
						offset = &AfricaKampalaZone.offset;
						savings = &AfricaKampalaZone.savings;
						
						return true;
					}
					else if (timezone < "Africa/Kampala") {
						if (timezone == "Africa/Cairo") {
							offset = &AfricaCairoZone.offset;
							savings = &AfricaCairoZone.savings;
							
							return true;
						}
						else if (timezone < "Africa/Cairo") {
							if (timezone == "Africa/Bangui") {
								offset = &AfricaBanguiZone.offset;
								savings = &AfricaBanguiZone.savings;
								
								return true;
							}
							else if (timezone < "Africa/Bangui") {
								if (timezone == "Africa/Algiers") {
									offset = &AfricaAlgiersZone.offset;
									savings = &AfricaAlgiersZone.savings;
									
									return true;
								}
								else if (timezone < "Africa/Algiers") {
									if (timezone == "Africa/Accra") {
										offset = &AfricaAccraZone.offset;
										savings = &AfricaAccraZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Accra") {
										if (timezone == "Africa/Abidjan") {
											offset = &AfricaAbidjanZone.offset;
											savings = &AfricaAbidjanZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "Africa/Addis_Ababa") {
											offset = &AfricaAddisAbabaZone.offset;
											savings = &AfricaAddisAbabaZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Africa/Bamako") {
										offset = &AfricaBamakoZone.offset;
										savings = &AfricaBamakoZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Bamako") {
										if (timezone == "Africa/Asmara") {
											offset = &AfricaAsmaraZone.offset;
											savings = &AfricaAsmaraZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Africa/Blantyre") {
									offset = &AfricaBlantyreZone.offset;
									savings = &AfricaBlantyreZone.savings;
									
									return true;
								}
								else if (timezone < "Africa/Blantyre") {
									if (timezone == "Africa/Bissau") {
										offset = &AfricaBissauZone.offset;
										savings = &AfricaBissauZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Bissau") {
										if (timezone == "Africa/Banjul") {
											offset = &AfricaBanjulZone.offset;
											savings = &AfricaBanjulZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Africa/Bujumbura") {
										offset = &AfricaBujumburaZone.offset;
										savings = &AfricaBujumburaZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Bujumbura") {
										if (timezone == "Africa/Brazzaville") {
											offset = &AfricaBrazzavilleZone.offset;
											savings = &AfricaBrazzavilleZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "Africa/Douala") {
								offset = &AfricaDoualaZone.offset;
								savings = &AfricaDoualaZone.savings;
								
								return true;
							}
							else if (timezone < "Africa/Douala") {
								if (timezone == "Africa/Dakar") {
									offset = &AfricaDakarZone.offset;
									savings = &AfricaDakarZone.savings;
									
									return true;
								}
								else if (timezone < "Africa/Dakar") {
									if (timezone == "Africa/Ceuta") {
										offset = &AfricaCeutaZone.offset;
										savings = &AfricaCeutaZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Ceuta") {
										if (timezone == "Africa/Casablanca") {
											offset = &AfricaCasablancaZone.offset;
											savings = &AfricaCasablancaZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "Africa/Conakry") {
											offset = &AfricaConakryZone.offset;
											savings = &AfricaConakryZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Africa/Djibouti") {
										offset = &AfricaDjiboutiZone.offset;
										savings = &AfricaDjiboutiZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Djibouti") {
										if (timezone == "Africa/Dar_es_Salaam") {
											offset = &AfricaDarEsSalaamZone.offset;
											savings = &AfricaDarEsSalaamZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Africa/Gaborone") {
									offset = &AfricaGaboroneZone.offset;
									savings = &AfricaGaboroneZone.savings;
									
									return true;
								}
								else if (timezone < "Africa/Gaborone") {
									if (timezone == "Africa/Freetown") {
										offset = &AfricaFreetownZone.offset;
										savings = &AfricaFreetownZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Freetown") {
										if (timezone == "Africa/El_Aaiun") {
											offset = &AfricaElAaiunZone.offset;
											savings = &AfricaElAaiunZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Africa/Johannesburg") {
										offset = &AfricaJohannesburgZone.offset;
										savings = &AfricaJohannesburgZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Johannesburg") {
										if (timezone == "Africa/Harare") {
											offset = &AfricaHarareZone.offset;
											savings = &AfricaHarareZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
					else {
						if (timezone == "Africa/Mbabane") {
							offset = &AfricaMbabaneZone.offset;
							savings = &AfricaMbabaneZone.savings;
							
							return true;
						}
						else if (timezone < "Africa/Mbabane") {
							if (timezone == "Africa/Luanda") {
								offset = &AfricaLuandaZone.offset;
								savings = &AfricaLuandaZone.savings;
								
								return true;
							}
							else if (timezone < "Africa/Luanda") {
								if (timezone == "Africa/Lagos") {
									offset = &AfricaLagosZone.offset;
									savings = &AfricaLagosZone.savings;
									
									return true;
								}
								else if (timezone < "Africa/Lagos") {
									if (timezone == "Africa/Kigali") {
										offset = &AfricaKigaliZone.offset;
										savings = &AfricaKigaliZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Kigali") {
										if (timezone == "Africa/Khartoum") {
											offset = &AfricaKhartoumZone.offset;
											savings = &AfricaKhartoumZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "Africa/Kinshasa") {
											offset = &AfricaKinshasaZone.offset;
											savings = &AfricaKinshasaZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Africa/Lome") {
										offset = &AfricaLomeZone.offset;
										savings = &AfricaLomeZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Lome") {
										if (timezone == "Africa/Libreville") {
											offset = &AfricaLibrevilleZone.offset;
											savings = &AfricaLibrevilleZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Africa/Malabo") {
									offset = &AfricaMalaboZone.offset;
									savings = &AfricaMalaboZone.savings;
									
									return true;
								}
								else if (timezone < "Africa/Malabo") {
									if (timezone == "Africa/Lusaka") {
										offset = &AfricaLusakaZone.offset;
										savings = &AfricaLusakaZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Lusaka") {
										if (timezone == "Africa/Lubumbashi") {
											offset = &AfricaLubumbashiZone.offset;
											savings = &AfricaLubumbashiZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Africa/Maseru") {
										offset = &AfricaMaseruZone.offset;
										savings = &AfricaMaseruZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Maseru") {
										if (timezone == "Africa/Maputo") {
											offset = &AfricaMaputoZone.offset;
											savings = &AfricaMaputoZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "Africa/Nouakchott") {
								offset = &AfricaNouakchottZone.offset;
								savings = &AfricaNouakchottZone.savings;
								
								return true;
							}
							else if (timezone < "Africa/Nouakchott") {
								if (timezone == "Africa/Nairobi") {
									offset = &AfricaNairobiZone.offset;
									savings = &AfricaNairobiZone.savings;
									
									return true;
								}
								else if (timezone < "Africa/Nairobi") {
									if (timezone == "Africa/Monrovia") {
										offset = &AfricaMonroviaZone.offset;
										savings = &AfricaMonroviaZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Monrovia") {
										if (timezone == "Africa/Mogadishu") {
											offset = &AfricaMogadishuZone.offset;
											savings = &AfricaMogadishuZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Africa/Niamey") {
										offset = &AfricaNiameyZone.offset;
										savings = &AfricaNiameyZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Niamey") {
										if (timezone == "Africa/Ndjamena") {
											offset = &AfricaNdjamenaZone.offset;
											savings = &AfricaNdjamenaZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Africa/Sao_Tome") {
									offset = &AfricaSaoTomeZone.offset;
									savings = &AfricaSaoTomeZone.savings;
									
									return true;
								}
								else if (timezone < "Africa/Sao_Tome") {
									if (timezone == "Africa/Porto-Novo") {
										offset = &AfricaPortoNovoZone.offset;
										savings = &AfricaPortoNovoZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Porto-Novo") {
										if (timezone == "Africa/Ouagadougou") {
											offset = &AfricaOuagadougouZone.offset;
											savings = &AfricaOuagadougouZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Africa/Tunis") {
										offset = &AfricaTunisZone.offset;
										savings = &AfricaTunisZone.savings;
										
										return true;
									}
									else if (timezone < "Africa/Tunis") {
										if (timezone == "Africa/Tripoli") {
											offset = &AfricaTripoliZone.offset;
											savings = &AfricaTripoliZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
				}
				else {
					if (timezone == "America/Blanc-Sablon") {
						offset = &AmericaBlancSablonZone.offset;
						savings = &AmericaBlancSablonZone.savings;
						
						return true;
					}
					else if (timezone < "America/Blanc-Sablon") {
						if (timezone == "America/Argentina/Salta") {
							offset = &AmericaArgentinaSaltaZone.offset;
							savings = &AmericaArgentinaSaltaZone.savings;
							
							return true;
						}
						else if (timezone < "America/Argentina/Salta") {
							if (timezone == "America/Argentina/Catamarca") {
								offset = &AmericaArgentinaCatamarcaZone.offset;
								savings = &AmericaArgentinaCatamarcaZone.savings;
								
								return true;
							}
							else if (timezone < "America/Argentina/Catamarca") {
								if (timezone == "America/Antigua") {
									offset = &AmericaAntiguaZone.offset;
									savings = &AmericaAntiguaZone.savings;
									
									return true;
								}
								else if (timezone < "America/Antigua") {
									if (timezone == "America/Anchorage") {
										offset = &AmericaAnchorageZone.offset;
										savings = &AmericaAnchorageZone.savings;
										
										return true;
									}
									else if (timezone < "America/Anchorage") {
										if (timezone == "America/Adak") {
											offset = &AmericaAdakZone.offset;
											savings = &AmericaAdakZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "America/Anguilla") {
											offset = &AmericaAnguillaZone.offset;
											savings = &AmericaAnguillaZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Argentina/Buenos_Aires") {
										offset = &AmericaArgentinaBuenosAiresZone.offset;
										savings = &AmericaArgentinaBuenosAiresZone.savings;
										
										return true;
									}
									else if (timezone < "America/Argentina/Buenos_Aires") {
										if (timezone == "America/Araguaina") {
											offset = &AmericaAraguainaZone.offset;
											savings = &AmericaAraguainaZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "America/Argentina/La_Rioja") {
									offset = &AmericaArgentinaLaRiojaZone.offset;
									savings = &AmericaArgentinaLaRiojaZone.savings;
									
									return true;
								}
								else if (timezone < "America/Argentina/La_Rioja") {
									if (timezone == "America/Argentina/Jujuy") {
										offset = &AmericaArgentinaJujuyZone.offset;
										savings = &AmericaArgentinaJujuyZone.savings;
										
										return true;
									}
									else if (timezone < "America/Argentina/Jujuy") {
										if (timezone == "America/Argentina/Cordoba") {
											offset = &AmericaArgentinaCordobaZone.offset;
											savings = &AmericaArgentinaCordobaZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Argentina/Rio_Gallegos") {
										offset = &AmericaArgentinaRioGallegosZone.offset;
										savings = &AmericaArgentinaRioGallegosZone.savings;
										
										return true;
									}
									else if (timezone < "America/Argentina/Rio_Gallegos") {
										if (timezone == "America/Argentina/Mendoza") {
											offset = &AmericaArgentinaMendozaZone.offset;
											savings = &AmericaArgentinaMendozaZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "America/Atikokan") {
								offset = &AmericaAtikokanZone.offset;
								savings = &AmericaAtikokanZone.savings;
								
								return true;
							}
							else if (timezone < "America/Atikokan") {
								if (timezone == "America/Argentina/Ushuaia") {
									offset = &AmericaArgentinaUshuaiaZone.offset;
									savings = &AmericaArgentinaUshuaiaZone.savings;
									
									return true;
								}
								else if (timezone < "America/Argentina/Ushuaia") {
									if (timezone == "America/Argentina/San_Luis") {
										offset = &AmericaArgentinaSanLuisZone.offset;
										savings = &AmericaArgentinaSanLuisZone.savings;
										
										return true;
									}
									else if (timezone < "America/Argentina/San_Luis") {
										if (timezone == "America/Argentina/San_Juan") {
											offset = &AmericaArgentinaSanJuanZone.offset;
											savings = &AmericaArgentinaSanJuanZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "America/Argentina/Tucuman") {
											offset = &AmericaArgentinaTucumanZone.offset;
											savings = &AmericaArgentinaTucumanZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Asuncion") {
										offset = &AmericaAsuncionZone.offset;
										savings = &AmericaAsuncionZone.savings;
										
										return true;
									}
									else if (timezone < "America/Asuncion") {
										if (timezone == "America/Aruba") {
											offset = &AmericaArubaZone.offset;
											savings = &AmericaArubaZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "America/Barbados") {
									offset = &AmericaBarbadosZone.offset;
									savings = &AmericaBarbadosZone.savings;
									
									return true;
								}
								else if (timezone < "America/Barbados") {
									if (timezone == "America/Bahia_Banderas") {
										offset = &AmericaBahiaBanderasZone.offset;
										savings = &AmericaBahiaBanderasZone.savings;
										
										return true;
									}
									else if (timezone < "America/Bahia_Banderas") {
										if (timezone == "America/Bahia") {
											offset = &AmericaBahiaZone.offset;
											savings = &AmericaBahiaZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Belize") {
										offset = &AmericaBelizeZone.offset;
										savings = &AmericaBelizeZone.savings;
										
										return true;
									}
									else if (timezone < "America/Belize") {
										if (timezone == "America/Belem") {
											offset = &AmericaBelemZone.offset;
											savings = &AmericaBelemZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
					else {
						if (timezone == "America/Cuiaba") {
							offset = &AmericaCuiabaZone.offset;
							savings = &AmericaCuiabaZone.savings;
							
							return true;
						}
						else if (timezone < "America/Cuiaba") {
							if (timezone == "America/Caracas") {
								offset = &AmericaCaracasZone.offset;
								savings = &AmericaCaracasZone.savings;
								
								return true;
							}
							else if (timezone < "America/Caracas") {
								if (timezone == "America/Cambridge_Bay") {
									offset = &AmericaCambridgeBayZone.offset;
									savings = &AmericaCambridgeBayZone.savings;
									
									return true;
								}
								else if (timezone < "America/Cambridge_Bay") {
									if (timezone == "America/Bogota") {
										offset = &AmericaBogotaZone.offset;
										savings = &AmericaBogotaZone.savings;
										
										return true;
									}
									else if (timezone < "America/Bogota") {
										if (timezone == "America/Boa_Vista") {
											offset = &AmericaBoaVistaZone.offset;
											savings = &AmericaBoaVistaZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "America/Boise") {
											offset = &AmericaBoiseZone.offset;
											savings = &AmericaBoiseZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Cancun") {
										offset = &AmericaCancunZone.offset;
										savings = &AmericaCancunZone.savings;
										
										return true;
									}
									else if (timezone < "America/Cancun") {
										if (timezone == "America/Campo_Grande") {
											offset = &AmericaCampoGrandeZone.offset;
											savings = &AmericaCampoGrandeZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "America/Chicago") {
									offset = &AmericaChicagoZone.offset;
									savings = &AmericaChicagoZone.savings;
									
									return true;
								}
								else if (timezone < "America/Chicago") {
									if (timezone == "America/Cayman") {
										offset = &AmericaCaymanZone.offset;
										savings = &AmericaCaymanZone.savings;
										
										return true;
									}
									else if (timezone < "America/Cayman") {
										if (timezone == "America/Cayenne") {
											offset = &AmericaCayenneZone.offset;
											savings = &AmericaCayenneZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Costa_Rica") {
										offset = &AmericaCostaRicaZone.offset;
										savings = &AmericaCostaRicaZone.savings;
										
										return true;
									}
									else if (timezone < "America/Costa_Rica") {
										if (timezone == "America/Chihuahua") {
											offset = &AmericaChihuahuaZone.offset;
											savings = &AmericaChihuahuaZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "America/Detroit") {
								offset = &AmericaDetroitZone.offset;
								savings = &AmericaDetroitZone.savings;
								
								return true;
							}
							else if (timezone < "America/Detroit") {
								if (timezone == "America/Dawson") {
									offset = &AmericaDawsonZone.offset;
									savings = &AmericaDawsonZone.savings;
									
									return true;
								}
								else if (timezone < "America/Dawson") {
									if (timezone == "America/Danmarkshavn") {
										offset = &AmericaDanmarkshavnZone.offset;
										savings = &AmericaDanmarkshavnZone.savings;
										
										return true;
									}
									else if (timezone < "America/Danmarkshavn") {
										if (timezone == "America/Curacao") {
											offset = &AmericaCuracaoZone.offset;
											savings = &AmericaCuracaoZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Denver") {
										offset = &AmericaDenverZone.offset;
										savings = &AmericaDenverZone.savings;
										
										return true;
									}
									else if (timezone < "America/Denver") {
										if (timezone == "America/Dawson_Creek") {
											offset = &AmericaDawsonCreekZone.offset;
											savings = &AmericaDawsonCreekZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "America/Eirunepe") {
									offset = &AmericaEirunepeZone.offset;
									savings = &AmericaEirunepeZone.savings;
									
									return true;
								}
								else if (timezone < "America/Eirunepe") {
									if (timezone == "America/Edmonton") {
										offset = &AmericaEdmontonZone.offset;
										savings = &AmericaEdmontonZone.savings;
										
										return true;
									}
									else if (timezone < "America/Edmonton") {
										if (timezone == "America/Dominica") {
											offset = &AmericaDominicaZone.offset;
											savings = &AmericaDominicaZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Fortaleza") {
										offset = &AmericaFortalezaZone.offset;
										savings = &AmericaFortalezaZone.savings;
										
										return true;
									}
									else if (timezone < "America/Fortaleza") {
										if (timezone == "America/El_Salvador") {
											offset = &AmericaElSalvadorZone.offset;
											savings = &AmericaElSalvadorZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
				}
			}
			else {
				if (timezone == "America/North_Dakota/Center") {
					offset = &AmericaNorthDakotaCenterZone.offset;
					savings = &AmericaNorthDakotaCenterZone.savings;
					
					return true;
				}
				else if (timezone < "America/North_Dakota/Center") {
					if (timezone == "America/La_Paz") {
						offset = &AmericaLaPazZone.offset;
						savings = &AmericaLaPazZone.savings;
						
						return true;
					}
					else if (timezone < "America/La_Paz") {
						if (timezone == "America/Indiana/Knox") {
							offset = &AmericaIndianaKnoxZone.offset;
							savings = &AmericaIndianaKnoxZone.savings;
							
							return true;
						}
						else if (timezone < "America/Indiana/Knox") {
							if (timezone == "America/Guayaquil") {
								offset = &AmericaGuayaquilZone.offset;
								savings = &AmericaGuayaquilZone.savings;
								
								return true;
							}
							else if (timezone < "America/Guayaquil") {
								if (timezone == "America/Grenada") {
									offset = &AmericaGrenadaZone.offset;
									savings = &AmericaGrenadaZone.savings;
									
									return true;
								}
								else if (timezone < "America/Grenada") {
									if (timezone == "America/Goose_Bay") {
										offset = &AmericaGooseBayZone.offset;
										savings = &AmericaGooseBayZone.savings;
										
										return true;
									}
									else if (timezone < "America/Goose_Bay") {
										if (timezone == "America/Godthab") {
											offset = &AmericaGodthabZone.offset;
											savings = &AmericaGodthabZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "America/Grand_Turk") {
											offset = &AmericaGrandTurkZone.offset;
											savings = &AmericaGrandTurkZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Guatemala") {
										offset = &AmericaGuatemalaZone.offset;
										savings = &AmericaGuatemalaZone.savings;
										
										return true;
									}
									else if (timezone < "America/Guatemala") {
										if (timezone == "America/Guadeloupe") {
											offset = &AmericaGuadeloupeZone.offset;
											savings = &AmericaGuadeloupeZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "America/Havana") {
									offset = &AmericaHavanaZone.offset;
									savings = &AmericaHavanaZone.savings;
									
									return true;
								}
								else if (timezone < "America/Havana") {
									if (timezone == "America/Halifax") {
										offset = &AmericaHalifaxZone.offset;
										savings = &AmericaHalifaxZone.savings;
										
										return true;
									}
									else if (timezone < "America/Halifax") {
										if (timezone == "America/Guyana") {
											offset = &AmericaGuyanaZone.offset;
											savings = &AmericaGuyanaZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Indiana/Indianapolis") {
										offset = &AmericaIndianaIndianapolisZone.offset;
										savings = &AmericaIndianaIndianapolisZone.savings;
										
										return true;
									}
									else if (timezone < "America/Indiana/Indianapolis") {
										if (timezone == "America/Hermosillo") {
											offset = &AmericaHermosilloZone.offset;
											savings = &AmericaHermosilloZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "America/Inuvik") {
								offset = &AmericaInuvikZone.offset;
								savings = &AmericaInuvikZone.savings;
								
								return true;
							}
							else if (timezone < "America/Inuvik") {
								if (timezone == "America/Indiana/Vevay") {
									offset = &AmericaIndianaVevayZone.offset;
									savings = &AmericaIndianaVevayZone.savings;
									
									return true;
								}
								else if (timezone < "America/Indiana/Vevay") {
									if (timezone == "America/Indiana/Petersburg") {
										offset = &AmericaIndianaPetersburgZone.offset;
										savings = &AmericaIndianaPetersburgZone.savings;
										
										return true;
									}
									else if (timezone < "America/Indiana/Petersburg") {
										if (timezone == "America/Indiana/Marengo") {
											offset = &AmericaIndianaMarengoZone.offset;
											savings = &AmericaIndianaMarengoZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "America/Indiana/Tell_City") {
											offset = &AmericaIndianaTellCityZone.offset;
											savings = &AmericaIndianaTellCityZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Indiana/Winamac") {
										offset = &AmericaIndianaWinamacZone.offset;
										savings = &AmericaIndianaWinamacZone.savings;
										
										return true;
									}
									else if (timezone < "America/Indiana/Winamac") {
										if (timezone == "America/Indiana/Vincennes") {
											offset = &AmericaIndianaVincennesZone.offset;
											savings = &AmericaIndianaVincennesZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "America/Juneau") {
									offset = &AmericaJuneauZone.offset;
									savings = &AmericaJuneauZone.savings;
									
									return true;
								}
								else if (timezone < "America/Juneau") {
									if (timezone == "America/Jamaica") {
										offset = &AmericaJamaicaZone.offset;
										savings = &AmericaJamaicaZone.savings;
										
										return true;
									}
									else if (timezone < "America/Jamaica") {
										if (timezone == "America/Iqaluit") {
											offset = &AmericaIqaluitZone.offset;
											savings = &AmericaIqaluitZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Kentucky/Monticello") {
										offset = &AmericaKentuckyMonticelloZone.offset;
										savings = &AmericaKentuckyMonticelloZone.savings;
										
										return true;
									}
									else if (timezone < "America/Kentucky/Monticello") {
										if (timezone == "America/Kentucky/Louisville") {
											offset = &AmericaKentuckyLouisvilleZone.offset;
											savings = &AmericaKentuckyLouisvilleZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
					else {
						if (timezone == "America/Miquelon") {
							offset = &AmericaMiquelonZone.offset;
							savings = &AmericaMiquelonZone.savings;
							
							return true;
						}
						else if (timezone < "America/Miquelon") {
							if (timezone == "America/Matamoros") {
								offset = &AmericaMatamorosZone.offset;
								savings = &AmericaMatamorosZone.savings;
								
								return true;
							}
							else if (timezone < "America/Matamoros") {
								if (timezone == "America/Managua") {
									offset = &AmericaManaguaZone.offset;
									savings = &AmericaManaguaZone.savings;
									
									return true;
								}
								else if (timezone < "America/Managua") {
									if (timezone == "America/Los_Angeles") {
										offset = &AmericaLosAngelesZone.offset;
										savings = &AmericaLosAngelesZone.savings;
										
										return true;
									}
									else if (timezone < "America/Los_Angeles") {
										if (timezone == "America/Lima") {
											offset = &AmericaLimaZone.offset;
											savings = &AmericaLimaZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "America/Maceio") {
											offset = &AmericaMaceioZone.offset;
											savings = &AmericaMaceioZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Martinique") {
										offset = &AmericaMartiniqueZone.offset;
										savings = &AmericaMartiniqueZone.savings;
										
										return true;
									}
									else if (timezone < "America/Martinique") {
										if (timezone == "America/Manaus") {
											offset = &AmericaManausZone.offset;
											savings = &AmericaManausZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "America/Merida") {
									offset = &AmericaMeridaZone.offset;
									savings = &AmericaMeridaZone.savings;
									
									return true;
								}
								else if (timezone < "America/Merida") {
									if (timezone == "America/Menominee") {
										offset = &AmericaMenomineeZone.offset;
										savings = &AmericaMenomineeZone.savings;
										
										return true;
									}
									else if (timezone < "America/Menominee") {
										if (timezone == "America/Mazatlan") {
											offset = &AmericaMazatlanZone.offset;
											savings = &AmericaMazatlanZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Mexico_City") {
										offset = &AmericaMexicoCityZone.offset;
										savings = &AmericaMexicoCityZone.savings;
										
										return true;
									}
									else if (timezone < "America/Mexico_City") {
										if (timezone == "America/Metlakatla") {
											offset = &AmericaMetlakatlaZone.offset;
											savings = &AmericaMetlakatlaZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "America/Nassau") {
								offset = &AmericaNassauZone.offset;
								savings = &AmericaNassauZone.savings;
								
								return true;
							}
							else if (timezone < "America/Nassau") {
								if (timezone == "America/Montevideo") {
									offset = &AmericaMontevideoZone.offset;
									savings = &AmericaMontevideoZone.savings;
									
									return true;
								}
								else if (timezone < "America/Montevideo") {
									if (timezone == "America/Monterrey") {
										offset = &AmericaMonterreyZone.offset;
										savings = &AmericaMonterreyZone.savings;
										
										return true;
									}
									else if (timezone < "America/Monterrey") {
										if (timezone == "America/Moncton") {
											offset = &AmericaMonctonZone.offset;
											savings = &AmericaMonctonZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Montserrat") {
										offset = &AmericaMontserratZone.offset;
										savings = &AmericaMontserratZone.savings;
										
										return true;
									}
									else if (timezone < "America/Montserrat") {
										if (timezone == "America/Montreal") {
											offset = &AmericaMontrealZone.offset;
											savings = &AmericaMontrealZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "America/Nome") {
									offset = &AmericaNomeZone.offset;
									savings = &AmericaNomeZone.savings;
									
									return true;
								}
								else if (timezone < "America/Nome") {
									if (timezone == "America/Nipigon") {
										offset = &AmericaNipigonZone.offset;
										savings = &AmericaNipigonZone.savings;
										
										return true;
									}
									else if (timezone < "America/Nipigon") {
										if (timezone == "America/New_York") {
											offset = &AmericaNewYorkZone.offset;
											savings = &AmericaNewYorkZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/North_Dakota/Beulah") {
										offset = &AmericaNorthDakotaBeulahZone.offset;
										savings = &AmericaNorthDakotaBeulahZone.savings;
										
										return true;
									}
									else if (timezone < "America/North_Dakota/Beulah") {
										if (timezone == "America/Noronha") {
											offset = &AmericaNoronhaZone.offset;
											savings = &AmericaNoronhaZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
				}
				else {
					if (timezone == "America/St_Kitts") {
						offset = &AmericaStKittsZone.offset;
						savings = &AmericaStKittsZone.savings;
						
						return true;
					}
					else if (timezone < "America/St_Kitts") {
						if (timezone == "America/Recife") {
							offset = &AmericaRecifeZone.offset;
							savings = &AmericaRecifeZone.savings;
							
							return true;
						}
						else if (timezone < "America/Recife") {
							if (timezone == "America/Port-au-Prince") {
								offset = &AmericaPortAuPrinceZone.offset;
								savings = &AmericaPortAuPrinceZone.savings;
								
								return true;
							}
							else if (timezone < "America/Port-au-Prince") {
								if (timezone == "America/Pangnirtung") {
									offset = &AmericaPangnirtungZone.offset;
									savings = &AmericaPangnirtungZone.savings;
									
									return true;
								}
								else if (timezone < "America/Pangnirtung") {
									if (timezone == "America/Ojinaga") {
										offset = &AmericaOjinagaZone.offset;
										savings = &AmericaOjinagaZone.savings;
										
										return true;
									}
									else if (timezone < "America/Ojinaga") {
										if (timezone == "America/North_Dakota/New_Salem") {
											offset = &AmericaNorthDakotaNewSalemZone.offset;
											savings = &AmericaNorthDakotaNewSalemZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "America/Panama") {
											offset = &AmericaPanamaZone.offset;
											savings = &AmericaPanamaZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Phoenix") {
										offset = &AmericaPhoenixZone.offset;
										savings = &AmericaPhoenixZone.savings;
										
										return true;
									}
									else if (timezone < "America/Phoenix") {
										if (timezone == "America/Paramaribo") {
											offset = &AmericaParamariboZone.offset;
											savings = &AmericaParamariboZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "America/Puerto_Rico") {
									offset = &AmericaPuertoRicoZone.offset;
									savings = &AmericaPuertoRicoZone.savings;
									
									return true;
								}
								else if (timezone < "America/Puerto_Rico") {
									if (timezone == "America/Porto_Velho") {
										offset = &AmericaPortoVelhoZone.offset;
										savings = &AmericaPortoVelhoZone.savings;
										
										return true;
									}
									else if (timezone < "America/Porto_Velho") {
										if (timezone == "America/Port_of_Spain") {
											offset = &AmericaPortOfSpainZone.offset;
											savings = &AmericaPortOfSpainZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Rankin_Inlet") {
										offset = &AmericaRankinInletZone.offset;
										savings = &AmericaRankinInletZone.savings;
										
										return true;
									}
									else if (timezone < "America/Rankin_Inlet") {
										if (timezone == "America/Rainy_River") {
											offset = &AmericaRainyRiverZone.offset;
											savings = &AmericaRainyRiverZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "America/Santiago") {
								offset = &AmericaSantiagoZone.offset;
								savings = &AmericaSantiagoZone.savings;
								
								return true;
							}
							else if (timezone < "America/Santiago") {
								if (timezone == "America/Rio_Branco") {
									offset = &AmericaRioBrancoZone.offset;
									savings = &AmericaRioBrancoZone.savings;
									
									return true;
								}
								else if (timezone < "America/Rio_Branco") {
									if (timezone == "America/Resolute") {
										offset = &AmericaResoluteZone.offset;
										savings = &AmericaResoluteZone.savings;
										
										return true;
									}
									else if (timezone < "America/Resolute") {
										if (timezone == "America/Regina") {
											offset = &AmericaReginaZone.offset;
											savings = &AmericaReginaZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Santarem") {
										offset = &AmericaSantaremZone.offset;
										savings = &AmericaSantaremZone.savings;
										
										return true;
									}
									else if (timezone < "America/Santarem") {
										if (timezone == "America/Santa_Isabel") {
											offset = &AmericaSantaIsabelZone.offset;
											savings = &AmericaSantaIsabelZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "America/Scoresbysund") {
									offset = &AmericaScoresbysundZone.offset;
									savings = &AmericaScoresbysundZone.savings;
									
									return true;
								}
								else if (timezone < "America/Scoresbysund") {
									if (timezone == "America/Sao_Paulo") {
										offset = &AmericaSaoPauloZone.offset;
										savings = &AmericaSaoPauloZone.savings;
										
										return true;
									}
									else if (timezone < "America/Sao_Paulo") {
										if (timezone == "America/Santo_Domingo") {
											offset = &AmericaSantoDomingoZone.offset;
											savings = &AmericaSantoDomingoZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/St_Johns") {
										offset = &AmericaStJohnsZone.offset;
										savings = &AmericaStJohnsZone.savings;
										
										return true;
									}
									else if (timezone < "America/St_Johns") {
										if (timezone == "America/Sitka") {
											offset = &AmericaSitkaZone.offset;
											savings = &AmericaSitkaZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
					else {
						if (timezone == "America/Winnipeg") {
							offset = &AmericaWinnipegZone.offset;
							savings = &AmericaWinnipegZone.savings;
							
							return true;
						}
						else if (timezone < "America/Winnipeg") {
							if (timezone == "America/Thunder_Bay") {
								offset = &AmericaThunderBayZone.offset;
								savings = &AmericaThunderBayZone.savings;
								
								return true;
							}
							else if (timezone < "America/Thunder_Bay") {
								if (timezone == "America/Swift_Current") {
									offset = &AmericaSwiftCurrentZone.offset;
									savings = &AmericaSwiftCurrentZone.savings;
									
									return true;
								}
								else if (timezone < "America/Swift_Current") {
									if (timezone == "America/St_Thomas") {
										offset = &AmericaStThomasZone.offset;
										savings = &AmericaStThomasZone.savings;
										
										return true;
									}
									else if (timezone < "America/St_Thomas") {
										if (timezone == "America/St_Lucia") {
											offset = &AmericaStLuciaZone.offset;
											savings = &AmericaStLuciaZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "America/St_Vincent") {
											offset = &AmericaStVincentZone.offset;
											savings = &AmericaStVincentZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Thule") {
										offset = &AmericaThuleZone.offset;
										savings = &AmericaThuleZone.savings;
										
										return true;
									}
									else if (timezone < "America/Thule") {
										if (timezone == "America/Tegucigalpa") {
											offset = &AmericaTegucigalpaZone.offset;
											savings = &AmericaTegucigalpaZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "America/Tortola") {
									offset = &AmericaTortolaZone.offset;
									savings = &AmericaTortolaZone.savings;
									
									return true;
								}
								else if (timezone < "America/Tortola") {
									if (timezone == "America/Toronto") {
										offset = &AmericaTorontoZone.offset;
										savings = &AmericaTorontoZone.savings;
										
										return true;
									}
									else if (timezone < "America/Toronto") {
										if (timezone == "America/Tijuana") {
											offset = &AmericaTijuanaZone.offset;
											savings = &AmericaTijuanaZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "America/Whitehorse") {
										offset = &AmericaWhitehorseZone.offset;
										savings = &AmericaWhitehorseZone.savings;
										
										return true;
									}
									else if (timezone < "America/Whitehorse") {
										if (timezone == "America/Vancouver") {
											offset = &AmericaVancouverZone.offset;
											savings = &AmericaVancouverZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "Antarctica/Macquarie") {
								offset = &AntarcticaMacquarieZone.offset;
								savings = &AntarcticaMacquarieZone.savings;
								
								return true;
							}
							else if (timezone < "Antarctica/Macquarie") {
								if (timezone == "Antarctica/Casey") {
									offset = &AntarcticaCaseyZone.offset;
									savings = &AntarcticaCaseyZone.savings;
									
									return true;
								}
								else if (timezone < "Antarctica/Casey") {
									if (timezone == "America/Yellowknife") {
										offset = &AmericaYellowknifeZone.offset;
										savings = &AmericaYellowknifeZone.savings;
										
										return true;
									}
									else if (timezone < "America/Yellowknife") {
										if (timezone == "America/Yakutat") {
											offset = &AmericaYakutatZone.offset;
											savings = &AmericaYakutatZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Antarctica/DumontDUrville") {
										offset = &AntarcticaDumontDUrvilleZone.offset;
										savings = &AntarcticaDumontDUrvilleZone.savings;
										
										return true;
									}
									else if (timezone < "Antarctica/DumontDUrville") {
										if (timezone == "Antarctica/Davis") {
											offset = &AntarcticaDavisZone.offset;
											savings = &AntarcticaDavisZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Antarctica/Palmer") {
									offset = &AntarcticaPalmerZone.offset;
									savings = &AntarcticaPalmerZone.savings;
									
									return true;
								}
								else if (timezone < "Antarctica/Palmer") {
									if (timezone == "Antarctica/McMurdo") {
										offset = &AntarcticaMcMurdoZone.offset;
										savings = &AntarcticaMcMurdoZone.savings;
										
										return true;
									}
									else if (timezone < "Antarctica/McMurdo") {
										if (timezone == "Antarctica/Mawson") {
											offset = &AntarcticaMawsonZone.offset;
											savings = &AntarcticaMawsonZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Antarctica/Syowa") {
										offset = &AntarcticaSyowaZone.offset;
										savings = &AntarcticaSyowaZone.savings;
										
										return true;
									}
									else if (timezone < "Antarctica/Syowa") {
										if (timezone == "Antarctica/Rothera") {
											offset = &AntarcticaRotheraZone.offset;
											savings = &AntarcticaRotheraZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
				}
			}
		}
		else {
			if (timezone == "EET") {
				offset = &EETZone.offset;
				savings = &EETZone.savings;
				
				return true;
			}
			else if (timezone < "EET") {
				if (timezone == "Asia/Oral") {
					offset = &AsiaOralZone.offset;
					savings = &AsiaOralZone.savings;
					
					return true;
				}
				else if (timezone < "Asia/Oral") {
					if (timezone == "Asia/Hong_Kong") {
						offset = &AsiaHongKongZone.offset;
						savings = &AsiaHongKongZone.savings;
						
						return true;
					}
					else if (timezone < "Asia/Hong_Kong") {
						if (timezone == "Asia/Bishkek") {
							offset = &AsiaBishkekZone.offset;
							savings = &AsiaBishkekZone.savings;
							
							return true;
						}
						else if (timezone < "Asia/Bishkek") {
							if (timezone == "Asia/Ashgabat") {
								offset = &AsiaAshgabatZone.offset;
								savings = &AsiaAshgabatZone.savings;
								
								return true;
							}
							else if (timezone < "Asia/Ashgabat") {
								if (timezone == "Asia/Anadyr") {
									offset = &AsiaAnadyrZone.offset;
									savings = &AsiaAnadyrZone.savings;
									
									return true;
								}
								else if (timezone < "Asia/Anadyr") {
									if (timezone == "Asia/Almaty") {
										offset = &AsiaAlmatyZone.offset;
										savings = &AsiaAlmatyZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Almaty") {
										if (timezone == "Asia/Aden") {
											offset = &AsiaAdenZone.offset;
											savings = &AsiaAdenZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "Asia/Amman") {
											offset = &AsiaAmmanZone.offset;
											savings = &AsiaAmmanZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Asia/Aqtobe") {
										offset = &AsiaAqtobeZone.offset;
										savings = &AsiaAqtobeZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Aqtobe") {
										if (timezone == "Asia/Aqtau") {
											offset = &AsiaAqtauZone.offset;
											savings = &AsiaAqtauZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Asia/Baku") {
									offset = &AsiaBakuZone.offset;
									savings = &AsiaBakuZone.savings;
									
									return true;
								}
								else if (timezone < "Asia/Baku") {
									if (timezone == "Asia/Bahrain") {
										offset = &AsiaBahrainZone.offset;
										savings = &AsiaBahrainZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Bahrain") {
										if (timezone == "Asia/Baghdad") {
											offset = &AsiaBaghdadZone.offset;
											savings = &AsiaBaghdadZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Asia/Beirut") {
										offset = &AsiaBeirutZone.offset;
										savings = &AsiaBeirutZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Beirut") {
										if (timezone == "Asia/Bangkok") {
											offset = &AsiaBangkokZone.offset;
											savings = &AsiaBangkokZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "Asia/Dili") {
								offset = &AsiaDiliZone.offset;
								savings = &AsiaDiliZone.savings;
								
								return true;
							}
							else if (timezone < "Asia/Dili") {
								if (timezone == "Asia/Colombo") {
									offset = &AsiaColomboZone.offset;
									savings = &AsiaColomboZone.savings;
									
									return true;
								}
								else if (timezone < "Asia/Colombo") {
									if (timezone == "Asia/Choibalsan") {
										offset = &AsiaChoibalsanZone.offset;
										savings = &AsiaChoibalsanZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Choibalsan") {
										if (timezone == "Asia/Brunei") {
											offset = &AsiaBruneiZone.offset;
											savings = &AsiaBruneiZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "Asia/Chongqing") {
											offset = &AsiaChongqingZone.offset;
											savings = &AsiaChongqingZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Asia/Dhaka") {
										offset = &AsiaDhakaZone.offset;
										savings = &AsiaDhakaZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Dhaka") {
										if (timezone == "Asia/Damascus") {
											offset = &AsiaDamascusZone.offset;
											savings = &AsiaDamascusZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Asia/Gaza") {
									offset = &AsiaGazaZone.offset;
									savings = &AsiaGazaZone.savings;
									
									return true;
								}
								else if (timezone < "Asia/Gaza") {
									if (timezone == "Asia/Dushanbe") {
										offset = &AsiaDushanbeZone.offset;
										savings = &AsiaDushanbeZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Dushanbe") {
										if (timezone == "Asia/Dubai") {
											offset = &AsiaDubaiZone.offset;
											savings = &AsiaDubaiZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Asia/Ho_Chi_Minh") {
										offset = &AsiaHoChiMinhZone.offset;
										savings = &AsiaHoChiMinhZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Ho_Chi_Minh") {
										if (timezone == "Asia/Harbin") {
											offset = &AsiaHarbinZone.offset;
											savings = &AsiaHarbinZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
					else {
						if (timezone == "Asia/Kuala_Lumpur") {
							offset = &AsiaKualaLumpurZone.offset;
							savings = &AsiaKualaLumpurZone.savings;
							
							return true;
						}
						else if (timezone < "Asia/Kuala_Lumpur") {
							if (timezone == "Asia/Kamchatka") {
								offset = &AsiaKamchatkaZone.offset;
								savings = &AsiaKamchatkaZone.savings;
								
								return true;
							}
							else if (timezone < "Asia/Kamchatka") {
								if (timezone == "Asia/Jayapura") {
									offset = &AsiaJayapuraZone.offset;
									savings = &AsiaJayapuraZone.savings;
									
									return true;
								}
								else if (timezone < "Asia/Jayapura") {
									if (timezone == "Asia/Irkutsk") {
										offset = &AsiaIrkutskZone.offset;
										savings = &AsiaIrkutskZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Irkutsk") {
										if (timezone == "Asia/Hovd") {
											offset = &AsiaHovdZone.offset;
											savings = &AsiaHovdZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "Asia/Jakarta") {
											offset = &AsiaJakartaZone.offset;
											savings = &AsiaJakartaZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Asia/Kabul") {
										offset = &AsiaKabulZone.offset;
										savings = &AsiaKabulZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Kabul") {
										if (timezone == "Asia/Jerusalem") {
											offset = &AsiaJerusalemZone.offset;
											savings = &AsiaJerusalemZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Asia/Kathmandu") {
									offset = &AsiaKathmanduZone.offset;
									savings = &AsiaKathmanduZone.savings;
									
									return true;
								}
								else if (timezone < "Asia/Kathmandu") {
									if (timezone == "Asia/Kashgar") {
										offset = &AsiaKashgarZone.offset;
										savings = &AsiaKashgarZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Kashgar") {
										if (timezone == "Asia/Karachi") {
											offset = &AsiaKarachiZone.offset;
											savings = &AsiaKarachiZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Asia/Krasnoyarsk") {
										offset = &AsiaKrasnoyarskZone.offset;
										savings = &AsiaKrasnoyarskZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Krasnoyarsk") {
										if (timezone == "Asia/Kolkata") {
											offset = &AsiaKolkataZone.offset;
											savings = &AsiaKolkataZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "Asia/Manila") {
								offset = &AsiaManilaZone.offset;
								savings = &AsiaManilaZone.savings;
								
								return true;
							}
							else if (timezone < "Asia/Manila") {
								if (timezone == "Asia/Macau") {
									offset = &AsiaMacauZone.offset;
									savings = &AsiaMacauZone.savings;
									
									return true;
								}
								else if (timezone < "Asia/Macau") {
									if (timezone == "Asia/Kuwait") {
										offset = &AsiaKuwaitZone.offset;
										savings = &AsiaKuwaitZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Kuwait") {
										if (timezone == "Asia/Kuching") {
											offset = &AsiaKuchingZone.offset;
											savings = &AsiaKuchingZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Asia/Makassar") {
										offset = &AsiaMakassarZone.offset;
										savings = &AsiaMakassarZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Makassar") {
										if (timezone == "Asia/Magadan") {
											offset = &AsiaMagadanZone.offset;
											savings = &AsiaMagadanZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Asia/Novokuznetsk") {
									offset = &AsiaNovokuznetskZone.offset;
									savings = &AsiaNovokuznetskZone.savings;
									
									return true;
								}
								else if (timezone < "Asia/Novokuznetsk") {
									if (timezone == "Asia/Nicosia") {
										offset = &AsiaNicosiaZone.offset;
										savings = &AsiaNicosiaZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Nicosia") {
										if (timezone == "Asia/Muscat") {
											offset = &AsiaMuscatZone.offset;
											savings = &AsiaMuscatZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Asia/Omsk") {
										offset = &AsiaOmskZone.offset;
										savings = &AsiaOmskZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Omsk") {
										if (timezone == "Asia/Novosibirsk") {
											offset = &AsiaNovosibirskZone.offset;
											savings = &AsiaNovosibirskZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
				}
				else {
					if (timezone == "Asia/Yerevan") {
						offset = &AsiaYerevanZone.offset;
						savings = &AsiaYerevanZone.savings;
						
						return true;
					}
					else if (timezone < "Asia/Yerevan") {
						if (timezone == "Asia/Taipei") {
							offset = &AsiaTaipeiZone.offset;
							savings = &AsiaTaipeiZone.savings;
							
							return true;
						}
						else if (timezone < "Asia/Taipei") {
							if (timezone == "Asia/Riyadh") {
								offset = &AsiaRiyadhZone.offset;
								savings = &AsiaRiyadhZone.savings;
								
								return true;
							}
							else if (timezone < "Asia/Riyadh") {
								if (timezone == "Asia/Qatar") {
									offset = &AsiaQatarZone.offset;
									savings = &AsiaQatarZone.savings;
									
									return true;
								}
								else if (timezone < "Asia/Qatar") {
									if (timezone == "Asia/Pontianak") {
										offset = &AsiaPontianakZone.offset;
										savings = &AsiaPontianakZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Pontianak") {
										if (timezone == "Asia/Phnom_Penh") {
											offset = &AsiaPhnomPenhZone.offset;
											savings = &AsiaPhnomPenhZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "Asia/Pyongyang") {
											offset = &AsiaPyongyangZone.offset;
											savings = &AsiaPyongyangZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Asia/Rangoon") {
										offset = &AsiaRangoonZone.offset;
										savings = &AsiaRangoonZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Rangoon") {
										if (timezone == "Asia/Qyzylorda") {
											offset = &AsiaQyzylordaZone.offset;
											savings = &AsiaQyzylordaZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Asia/Seoul") {
									offset = &AsiaSeoulZone.offset;
									savings = &AsiaSeoulZone.savings;
									
									return true;
								}
								else if (timezone < "Asia/Seoul") {
									if (timezone == "Asia/Samarkand") {
										offset = &AsiaSamarkandZone.offset;
										savings = &AsiaSamarkandZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Samarkand") {
										if (timezone == "Asia/Sakhalin") {
											offset = &AsiaSakhalinZone.offset;
											savings = &AsiaSakhalinZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Asia/Singapore") {
										offset = &AsiaSingaporeZone.offset;
										savings = &AsiaSingaporeZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Singapore") {
										if (timezone == "Asia/Shanghai") {
											offset = &AsiaShanghaiZone.offset;
											savings = &AsiaShanghaiZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "Asia/Ulaanbaatar") {
								offset = &AsiaUlaanbaatarZone.offset;
								savings = &AsiaUlaanbaatarZone.savings;
								
								return true;
							}
							else if (timezone < "Asia/Ulaanbaatar") {
								if (timezone == "Asia/Tehran") {
									offset = &AsiaTehranZone.offset;
									savings = &AsiaTehranZone.savings;
									
									return true;
								}
								else if (timezone < "Asia/Tehran") {
									if (timezone == "Asia/Tbilisi") {
										offset = &AsiaTbilisiZone.offset;
										savings = &AsiaTbilisiZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Tbilisi") {
										if (timezone == "Asia/Tashkent") {
											offset = &AsiaTashkentZone.offset;
											savings = &AsiaTashkentZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Asia/Tokyo") {
										offset = &AsiaTokyoZone.offset;
										savings = &AsiaTokyoZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Tokyo") {
										if (timezone == "Asia/Thimphu") {
											offset = &AsiaThimphuZone.offset;
											savings = &AsiaThimphuZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Asia/Vladivostok") {
									offset = &AsiaVladivostokZone.offset;
									savings = &AsiaVladivostokZone.savings;
									
									return true;
								}
								else if (timezone < "Asia/Vladivostok") {
									if (timezone == "Asia/Vientiane") {
										offset = &AsiaVientianeZone.offset;
										savings = &AsiaVientianeZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Vientiane") {
										if (timezone == "Asia/Urumqi") {
											offset = &AsiaUrumqiZone.offset;
											savings = &AsiaUrumqiZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Asia/Yekaterinburg") {
										offset = &AsiaYekaterinburgZone.offset;
										savings = &AsiaYekaterinburgZone.savings;
										
										return true;
									}
									else if (timezone < "Asia/Yekaterinburg") {
										if (timezone == "Asia/Yakutsk") {
											offset = &AsiaYakutskZone.offset;
											savings = &AsiaYakutskZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
					else {
						if (timezone == "Australia/Broken_Hill") {
							offset = &AustraliaBrokenHillZone.offset;
							savings = &AustraliaBrokenHillZone.savings;
							
							return true;
						}
						else if (timezone < "Australia/Broken_Hill") {
							if (timezone == "Atlantic/Reykjavik") {
								offset = &AtlanticReykjavikZone.offset;
								savings = &AtlanticReykjavikZone.savings;
								
								return true;
							}
							else if (timezone < "Atlantic/Reykjavik") {
								if (timezone == "Atlantic/Cape_Verde") {
									offset = &AtlanticCapeVerdeZone.offset;
									savings = &AtlanticCapeVerdeZone.savings;
									
									return true;
								}
								else if (timezone < "Atlantic/Cape_Verde") {
									if (timezone == "Atlantic/Bermuda") {
										offset = &AtlanticBermudaZone.offset;
										savings = &AtlanticBermudaZone.savings;
										
										return true;
									}
									else if (timezone < "Atlantic/Bermuda") {
										if (timezone == "Atlantic/Azores") {
											offset = &AtlanticAzoresZone.offset;
											savings = &AtlanticAzoresZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "Atlantic/Canary") {
											offset = &AtlanticCanaryZone.offset;
											savings = &AtlanticCanaryZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Atlantic/Madeira") {
										offset = &AtlanticMadeiraZone.offset;
										savings = &AtlanticMadeiraZone.savings;
										
										return true;
									}
									else if (timezone < "Atlantic/Madeira") {
										if (timezone == "Atlantic/Faroe") {
											offset = &AtlanticFaroeZone.offset;
											savings = &AtlanticFaroeZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Atlantic/Stanley") {
									offset = &AtlanticStanleyZone.offset;
									savings = &AtlanticStanleyZone.savings;
									
									return true;
								}
								else if (timezone < "Atlantic/Stanley") {
									if (timezone == "Atlantic/St_Helena") {
										offset = &AtlanticStHelenaZone.offset;
										savings = &AtlanticStHelenaZone.savings;
										
										return true;
									}
									else if (timezone < "Atlantic/St_Helena") {
										if (timezone == "Atlantic/South_Georgia") {
											offset = &AtlanticSouthGeorgiaZone.offset;
											savings = &AtlanticSouthGeorgiaZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Australia/Brisbane") {
										offset = &AustraliaBrisbaneZone.offset;
										savings = &AustraliaBrisbaneZone.savings;
										
										return true;
									}
									else if (timezone < "Australia/Brisbane") {
										if (timezone == "Australia/Adelaide") {
											offset = &AustraliaAdelaideZone.offset;
											savings = &AustraliaAdelaideZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "Australia/Lord_Howe") {
								offset = &AustraliaLordHoweZone.offset;
								savings = &AustraliaLordHoweZone.savings;
								
								return true;
							}
							else if (timezone < "Australia/Lord_Howe") {
								if (timezone == "Australia/Eucla") {
									offset = &AustraliaEuclaZone.offset;
									savings = &AustraliaEuclaZone.savings;
									
									return true;
								}
								else if (timezone < "Australia/Eucla") {
									if (timezone == "Australia/Darwin") {
										offset = &AustraliaDarwinZone.offset;
										savings = &AustraliaDarwinZone.savings;
										
										return true;
									}
									else if (timezone < "Australia/Darwin") {
										if (timezone == "Australia/Currie") {
											offset = &AustraliaCurrieZone.offset;
											savings = &AustraliaCurrieZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Australia/Lindeman") {
										offset = &AustraliaLindemanZone.offset;
										savings = &AustraliaLindemanZone.savings;
										
										return true;
									}
									else if (timezone < "Australia/Lindeman") {
										if (timezone == "Australia/Hobart") {
											offset = &AustraliaHobartZone.offset;
											savings = &AustraliaHobartZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Australia/Sydney") {
									offset = &AustraliaSydneyZone.offset;
									savings = &AustraliaSydneyZone.savings;
									
									return true;
								}
								else if (timezone < "Australia/Sydney") {
									if (timezone == "Australia/Perth") {
										offset = &AustraliaPerthZone.offset;
										savings = &AustraliaPerthZone.savings;
										
										return true;
									}
									else if (timezone < "Australia/Perth") {
										if (timezone == "Australia/Melbourne") {
											offset = &AustraliaMelbourneZone.offset;
											savings = &AustraliaMelbourneZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "CST6CDT") {
										offset = &CST6CDTZone.offset;
										savings = &CST6CDTZone.savings;
										
										return true;
									}
									else if (timezone < "CST6CDT") {
										if (timezone == "CET") {
											offset = &CETZone.offset;
											savings = &CETZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
				}
			}
			else {
				if (timezone == "Indian/Comoro") {
					offset = &IndianComoroZone.offset;
					savings = &IndianComoroZone.savings;
					
					return true;
				}
				else if (timezone < "Indian/Comoro") {
					if (timezone == "Europe/Moscow") {
						offset = &EuropeMoscowZone.offset;
						savings = &EuropeMoscowZone.savings;
						
						return true;
					}
					else if (timezone < "Europe/Moscow") {
						if (timezone == "Europe/Dublin") {
							offset = &EuropeDublinZone.offset;
							savings = &EuropeDublinZone.savings;
							
							return true;
						}
						else if (timezone < "Europe/Dublin") {
							if (timezone == "Europe/Berlin") {
								offset = &EuropeBerlinZone.offset;
								savings = &EuropeBerlinZone.savings;
								
								return true;
							}
							else if (timezone < "Europe/Berlin") {
								if (timezone == "Europe/Andorra") {
									offset = &EuropeAndorraZone.offset;
									savings = &EuropeAndorraZone.savings;
									
									return true;
								}
								else if (timezone < "Europe/Andorra") {
									if (timezone == "EST5EDT") {
										offset = &EST5EDTZone.offset;
										savings = &EST5EDTZone.savings;
										
										return true;
									}
									else if (timezone < "EST5EDT") {
										if (timezone == "EST") {
											offset = &ESTZone.offset;
											savings = &ESTZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "Europe/Amsterdam") {
											offset = &EuropeAmsterdamZone.offset;
											savings = &EuropeAmsterdamZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Europe/Belgrade") {
										offset = &EuropeBelgradeZone.offset;
										savings = &EuropeBelgradeZone.savings;
										
										return true;
									}
									else if (timezone < "Europe/Belgrade") {
										if (timezone == "Europe/Athens") {
											offset = &EuropeAthensZone.offset;
											savings = &EuropeAthensZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Europe/Budapest") {
									offset = &EuropeBudapestZone.offset;
									savings = &EuropeBudapestZone.savings;
									
									return true;
								}
								else if (timezone < "Europe/Budapest") {
									if (timezone == "Europe/Bucharest") {
										offset = &EuropeBucharestZone.offset;
										savings = &EuropeBucharestZone.savings;
										
										return true;
									}
									else if (timezone < "Europe/Bucharest") {
										if (timezone == "Europe/Brussels") {
											offset = &EuropeBrusselsZone.offset;
											savings = &EuropeBrusselsZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Europe/Copenhagen") {
										offset = &EuropeCopenhagenZone.offset;
										savings = &EuropeCopenhagenZone.savings;
										
										return true;
									}
									else if (timezone < "Europe/Copenhagen") {
										if (timezone == "Europe/Chisinau") {
											offset = &EuropeChisinauZone.offset;
											savings = &EuropeChisinauZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "Europe/London") {
								offset = &EuropeLondonZone.offset;
								savings = &EuropeLondonZone.savings;
								
								return true;
							}
							else if (timezone < "Europe/London") {
								if (timezone == "Europe/Kaliningrad") {
									offset = &EuropeKaliningradZone.offset;
									savings = &EuropeKaliningradZone.savings;
									
									return true;
								}
								else if (timezone < "Europe/Kaliningrad") {
									if (timezone == "Europe/Helsinki") {
										offset = &EuropeHelsinkiZone.offset;
										savings = &EuropeHelsinkiZone.savings;
										
										return true;
									}
									else if (timezone < "Europe/Helsinki") {
										if (timezone == "Europe/Gibraltar") {
											offset = &EuropeGibraltarZone.offset;
											savings = &EuropeGibraltarZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "Europe/Istanbul") {
											offset = &EuropeIstanbulZone.offset;
											savings = &EuropeIstanbulZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Europe/Lisbon") {
										offset = &EuropeLisbonZone.offset;
										savings = &EuropeLisbonZone.savings;
										
										return true;
									}
									else if (timezone < "Europe/Lisbon") {
										if (timezone == "Europe/Kiev") {
											offset = &EuropeKievZone.offset;
											savings = &EuropeKievZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Europe/Malta") {
									offset = &EuropeMaltaZone.offset;
									savings = &EuropeMaltaZone.savings;
									
									return true;
								}
								else if (timezone < "Europe/Malta") {
									if (timezone == "Europe/Madrid") {
										offset = &EuropeMadridZone.offset;
										savings = &EuropeMadridZone.savings;
										
										return true;
									}
									else if (timezone < "Europe/Madrid") {
										if (timezone == "Europe/Luxembourg") {
											offset = &EuropeLuxembourgZone.offset;
											savings = &EuropeLuxembourgZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Europe/Monaco") {
										offset = &EuropeMonacoZone.offset;
										savings = &EuropeMonacoZone.savings;
										
										return true;
									}
									else if (timezone < "Europe/Monaco") {
										if (timezone == "Europe/Minsk") {
											offset = &EuropeMinskZone.offset;
											savings = &EuropeMinskZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
					else {
						if (timezone == "Europe/Vaduz") {
							offset = &EuropeVaduzZone.offset;
							savings = &EuropeVaduzZone.savings;
							
							return true;
						}
						else if (timezone < "Europe/Vaduz") {
							if (timezone == "Europe/Simferopol") {
								offset = &EuropeSimferopolZone.offset;
								savings = &EuropeSimferopolZone.savings;
								
								return true;
							}
							else if (timezone < "Europe/Simferopol") {
								if (timezone == "Europe/Riga") {
									offset = &EuropeRigaZone.offset;
									savings = &EuropeRigaZone.savings;
									
									return true;
								}
								else if (timezone < "Europe/Riga") {
									if (timezone == "Europe/Paris") {
										offset = &EuropeParisZone.offset;
										savings = &EuropeParisZone.savings;
										
										return true;
									}
									else if (timezone < "Europe/Paris") {
										if (timezone == "Europe/Oslo") {
											offset = &EuropeOsloZone.offset;
											savings = &EuropeOsloZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "Europe/Prague") {
											offset = &EuropePragueZone.offset;
											savings = &EuropePragueZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Europe/Samara") {
										offset = &EuropeSamaraZone.offset;
										savings = &EuropeSamaraZone.savings;
										
										return true;
									}
									else if (timezone < "Europe/Samara") {
										if (timezone == "Europe/Rome") {
											offset = &EuropeRomeZone.offset;
											savings = &EuropeRomeZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Europe/Tallinn") {
									offset = &EuropeTallinnZone.offset;
									savings = &EuropeTallinnZone.savings;
									
									return true;
								}
								else if (timezone < "Europe/Tallinn") {
									if (timezone == "Europe/Stockholm") {
										offset = &EuropeStockholmZone.offset;
										savings = &EuropeStockholmZone.savings;
										
										return true;
									}
									else if (timezone < "Europe/Stockholm") {
										if (timezone == "Europe/Sofia") {
											offset = &EuropeSofiaZone.offset;
											savings = &EuropeSofiaZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Europe/Uzhgorod") {
										offset = &EuropeUzhgorodZone.offset;
										savings = &EuropeUzhgorodZone.savings;
										
										return true;
									}
									else if (timezone < "Europe/Uzhgorod") {
										if (timezone == "Europe/Tirane") {
											offset = &EuropeTiraneZone.offset;
											savings = &EuropeTiraneZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "Europe/Zurich") {
								offset = &EuropeZurichZone.offset;
								savings = &EuropeZurichZone.savings;
								
								return true;
							}
							else if (timezone < "Europe/Zurich") {
								if (timezone == "Europe/Volgograd") {
									offset = &EuropeVolgogradZone.offset;
									savings = &EuropeVolgogradZone.savings;
									
									return true;
								}
								else if (timezone < "Europe/Volgograd") {
									if (timezone == "Europe/Vilnius") {
										offset = &EuropeVilniusZone.offset;
										savings = &EuropeVilniusZone.savings;
										
										return true;
									}
									else if (timezone < "Europe/Vilnius") {
										if (timezone == "Europe/Vienna") {
											offset = &EuropeViennaZone.offset;
											savings = &EuropeViennaZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Europe/Zaporozhye") {
										offset = &EuropeZaporozhyeZone.offset;
										savings = &EuropeZaporozhyeZone.savings;
										
										return true;
									}
									else if (timezone < "Europe/Zaporozhye") {
										if (timezone == "Europe/Warsaw") {
											offset = &EuropeWarsawZone.offset;
											savings = &EuropeWarsawZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Indian/Chagos") {
									offset = &IndianChagosZone.offset;
									savings = &IndianChagosZone.savings;
									
									return true;
								}
								else if (timezone < "Indian/Chagos") {
									if (timezone == "Indian/Antananarivo") {
										offset = &IndianAntananarivoZone.offset;
										savings = &IndianAntananarivoZone.savings;
										
										return true;
									}
									else if (timezone < "Indian/Antananarivo") {
										if (timezone == "HST") {
											offset = &HSTZone.offset;
											savings = &HSTZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Indian/Cocos") {
										offset = &IndianCocosZone.offset;
										savings = &IndianCocosZone.savings;
										
										return true;
									}
									else if (timezone < "Indian/Cocos") {
										if (timezone == "Indian/Christmas") {
											offset = &IndianChristmasZone.offset;
											savings = &IndianChristmasZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
				}
				else {
					if (timezone == "Pacific/Honolulu") {
						offset = &PacificHonoluluZone.offset;
						savings = &PacificHonoluluZone.savings;
						
						return true;
					}
					else if (timezone < "Pacific/Honolulu") {
						if (timezone == "Pacific/Chatham") {
							offset = &PacificChathamZone.offset;
							savings = &PacificChathamZone.savings;
							
							return true;
						}
						else if (timezone < "Pacific/Chatham") {
							if (timezone == "MET") {
								offset = &METZone.offset;
								savings = &METZone.savings;
								
								return true;
							}
							else if (timezone < "MET") {
								if (timezone == "Indian/Mauritius") {
									offset = &IndianMauritiusZone.offset;
									savings = &IndianMauritiusZone.savings;
									
									return true;
								}
								else if (timezone < "Indian/Mauritius") {
									if (timezone == "Indian/Mahe") {
										offset = &IndianMaheZone.offset;
										savings = &IndianMaheZone.savings;
										
										return true;
									}
									else if (timezone < "Indian/Mahe") {
										if (timezone == "Indian/Kerguelen") {
											offset = &IndianKerguelenZone.offset;
											savings = &IndianKerguelenZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "Indian/Maldives") {
											offset = &IndianMaldivesZone.offset;
											savings = &IndianMaldivesZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Indian/Reunion") {
										offset = &IndianReunionZone.offset;
										savings = &IndianReunionZone.savings;
										
										return true;
									}
									else if (timezone < "Indian/Reunion") {
										if (timezone == "Indian/Mayotte") {
											offset = &IndianMayotteZone.offset;
											savings = &IndianMayotteZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "PST8PDT") {
									offset = &PST8PDTZone.offset;
									savings = &PST8PDTZone.savings;
									
									return true;
								}
								else if (timezone < "PST8PDT") {
									if (timezone == "MST7MDT") {
										offset = &MST7MDTZone.offset;
										savings = &MST7MDTZone.savings;
										
										return true;
									}
									else if (timezone < "MST7MDT") {
										if (timezone == "MST") {
											offset = &MSTZone.offset;
											savings = &MSTZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Pacific/Auckland") {
										offset = &PacificAucklandZone.offset;
										savings = &PacificAucklandZone.savings;
										
										return true;
									}
									else if (timezone < "Pacific/Auckland") {
										if (timezone == "Pacific/Apia") {
											offset = &PacificApiaZone.offset;
											savings = &PacificApiaZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "Pacific/Fiji") {
								offset = &PacificFijiZone.offset;
								savings = &PacificFijiZone.savings;
								
								return true;
							}
							else if (timezone < "Pacific/Fiji") {
								if (timezone == "Pacific/Efate") {
									offset = &PacificEfateZone.offset;
									savings = &PacificEfateZone.savings;
									
									return true;
								}
								else if (timezone < "Pacific/Efate") {
									if (timezone == "Pacific/Easter") {
										offset = &PacificEasterZone.offset;
										savings = &PacificEasterZone.savings;
										
										return true;
									}
									else if (timezone < "Pacific/Easter") {
										if (timezone == "Pacific/Chuuk") {
											offset = &PacificChuukZone.offset;
											savings = &PacificChuukZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Pacific/Fakaofo") {
										offset = &PacificFakaofoZone.offset;
										savings = &PacificFakaofoZone.savings;
										
										return true;
									}
									else if (timezone < "Pacific/Fakaofo") {
										if (timezone == "Pacific/Enderbury") {
											offset = &PacificEnderburyZone.offset;
											savings = &PacificEnderburyZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Pacific/Gambier") {
									offset = &PacificGambierZone.offset;
									savings = &PacificGambierZone.savings;
									
									return true;
								}
								else if (timezone < "Pacific/Gambier") {
									if (timezone == "Pacific/Galapagos") {
										offset = &PacificGalapagosZone.offset;
										savings = &PacificGalapagosZone.savings;
										
										return true;
									}
									else if (timezone < "Pacific/Galapagos") {
										if (timezone == "Pacific/Funafuti") {
											offset = &PacificFunafutiZone.offset;
											savings = &PacificFunafutiZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Pacific/Guam") {
										offset = &PacificGuamZone.offset;
										savings = &PacificGuamZone.savings;
										
										return true;
									}
									else if (timezone < "Pacific/Guam") {
										if (timezone == "Pacific/Guadalcanal") {
											offset = &PacificGuadalcanalZone.offset;
											savings = &PacificGuadalcanalZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
					else {
						if (timezone == "Pacific/Palau") {
							offset = &PacificPalauZone.offset;
							savings = &PacificPalauZone.savings;
							
							return true;
						}
						else if (timezone < "Pacific/Palau") {
							if (timezone == "Pacific/Midway") {
								offset = &PacificMidwayZone.offset;
								savings = &PacificMidwayZone.savings;
								
								return true;
							}
							else if (timezone < "Pacific/Midway") {
								if (timezone == "Pacific/Kwajalein") {
									offset = &PacificKwajaleinZone.offset;
									savings = &PacificKwajaleinZone.savings;
									
									return true;
								}
								else if (timezone < "Pacific/Kwajalein") {
									if (timezone == "Pacific/Kiritimati") {
										offset = &PacificKiritimatiZone.offset;
										savings = &PacificKiritimatiZone.savings;
										
										return true;
									}
									else if (timezone < "Pacific/Kiritimati") {
										if (timezone == "Pacific/Johnston") {
											offset = &PacificJohnstonZone.offset;
											savings = &PacificJohnstonZone.savings;
											
											return true;
										}
									}
									else {
										if (timezone == "Pacific/Kosrae") {
											offset = &PacificKosraeZone.offset;
											savings = &PacificKosraeZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Pacific/Marquesas") {
										offset = &PacificMarquesasZone.offset;
										savings = &PacificMarquesasZone.savings;
										
										return true;
									}
									else if (timezone < "Pacific/Marquesas") {
										if (timezone == "Pacific/Majuro") {
											offset = &PacificMajuroZone.offset;
											savings = &PacificMajuroZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Pacific/Norfolk") {
									offset = &PacificNorfolkZone.offset;
									savings = &PacificNorfolkZone.savings;
									
									return true;
								}
								else if (timezone < "Pacific/Norfolk") {
									if (timezone == "Pacific/Niue") {
										offset = &PacificNiueZone.offset;
										savings = &PacificNiueZone.savings;
										
										return true;
									}
									else if (timezone < "Pacific/Niue") {
										if (timezone == "Pacific/Nauru") {
											offset = &PacificNauruZone.offset;
											savings = &PacificNauruZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Pacific/Pago_Pago") {
										offset = &PacificPagoPagoZone.offset;
										savings = &PacificPagoPagoZone.savings;
										
										return true;
									}
									else if (timezone < "Pacific/Pago_Pago") {
										if (timezone == "Pacific/Noumea") {
											offset = &PacificNoumeaZone.offset;
											savings = &PacificNoumeaZone.savings;
											
											return true;
										}
									}
								}
							}
						}
						else {
							if (timezone == "Pacific/Tahiti") {
								offset = &PacificTahitiZone.offset;
								savings = &PacificTahitiZone.savings;
								
								return true;
							}
							else if (timezone < "Pacific/Tahiti") {
								if (timezone == "Pacific/Port_Moresby") {
									offset = &PacificPortMoresbyZone.offset;
									savings = &PacificPortMoresbyZone.savings;
									
									return true;
								}
								else if (timezone < "Pacific/Port_Moresby") {
									if (timezone == "Pacific/Pohnpei") {
										offset = &PacificPohnpeiZone.offset;
										savings = &PacificPohnpeiZone.savings;
										
										return true;
									}
									else if (timezone < "Pacific/Pohnpei") {
										if (timezone == "Pacific/Pitcairn") {
											offset = &PacificPitcairnZone.offset;
											savings = &PacificPitcairnZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "Pacific/Saipan") {
										offset = &PacificSaipanZone.offset;
										savings = &PacificSaipanZone.savings;
										
										return true;
									}
									else if (timezone < "Pacific/Saipan") {
										if (timezone == "Pacific/Rarotonga") {
											offset = &PacificRarotongaZone.offset;
											savings = &PacificRarotongaZone.savings;
											
											return true;
										}
									}
								}
							}
							else {
								if (timezone == "Pacific/Wake") {
									offset = &PacificWakeZone.offset;
									savings = &PacificWakeZone.savings;
									
									return true;
								}
								else if (timezone < "Pacific/Wake") {
									if (timezone == "Pacific/Tongatapu") {
										offset = &PacificTongatapuZone.offset;
										savings = &PacificTongatapuZone.savings;
										
										return true;
									}
									else if (timezone < "Pacific/Tongatapu") {
										if (timezone == "Pacific/Tarawa") {
											offset = &PacificTarawaZone.offset;
											savings = &PacificTarawaZone.savings;
											
											return true;
										}
									}
								}
								else {
									if (timezone == "WET") {
										offset = &WETZone.offset;
										savings = &WETZone.savings;
										
										return true;
									}
									else if (timezone < "WET") {
										if (timezone == "Pacific/Wallis") {
											offset = &PacificWallisZone.offset;
											savings = &PacificWallisZone.savings;
											
											return true;
										}
									}
								}
							}
						}
					}
				}
			}
		}
		
		return false;
	}
}

