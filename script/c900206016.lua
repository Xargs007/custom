--祝福の教会－リチューアル・チャーチ
--Ritual Sanctuary
--Script by dest
function c900206016.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(900206016,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,900206016)
	e2:SetCost(c900206016.thcost)
	e2:SetTarget(c900206016.thtg)
	e2:SetOperation(c900206016.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(900206016,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,100206116)
	e3:SetCost(c900206016.spcost)
	e3:SetTarget(c900206016.sptg)
	e3:SetOperation(c900206016.spop)
	c:RegisterEffect(e3)
end
function c900206016.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c900206016.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c900206016.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c900206016.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c900206016.thfilter(c)
	return ((c:IsType(TYPE_MONSTER) and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_EARTH))) or c:IsType(TYPE_SPELL))
		and c:IsType(TYPE_RITUAL)  and c:IsAbleToHand()
end
function c900206016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c900206016.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c900206016.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c900206016.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c900206016.spfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c900206016.cfilter2,tp,LOCATION_GRAVE,0,lv,nil)
end
function c900206016.cfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToDeckAsCost()
end
function c900206016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c900206016.spfilter2(c,e,tp,lv)
	return c:GetLevel()==lv and ((c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY)) or (c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c900206016.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c900206016.spfilter2(chkc,e,tp,e:GetLabel()) end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c900206016.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c900206016.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local lv=g:GetFirst():GetLevel()
	e:SetLabel(lv)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,c900206016.cfilter2,tp,LOCATION_GRAVE,0,lv,lv,nil)
	Duel.SendtoDeck(tg,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c900206016.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
