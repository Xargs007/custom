--レモン・マジシャン・ガール
--Lemon Magician Girl
function c980014003.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(980014003,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c980014003.thcost)
	e1:SetTarget(c980014003.thtg)
	e1:SetOperation(c980014003.thop)
	c:RegisterEffect(e1)
	--Special Summon + change battle target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(980014003,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c980014003.sptg)
	e2:SetOperation(c980014003.spop)
	c:RegisterEffect(e2)
end
function c980014003.cfilter(c)
	return (c:IsSetCard(0x20a2) or c:IsSetCard(0x30a2) or c:IsCode(38033121) or c:IsCode(100200115) or c:IsCode(80304126) or c:IsCode(100200115)) and not c:IsCode(980014003)
end
function c980014003.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c980014003.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c980014003.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c980014003.filter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c980014003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c980014003.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c980014003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c980014003.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c980014003.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c980014003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c980014003.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c980014003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c980014003.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		local at=Duel.GetAttacker()
		if at and at:IsAttackable() and at:IsFaceup() and not at:IsImmuneToEffect(e) and not at:IsStatus(STATUS_ATTACK_CANCELED) then
			Duel.BreakEffect()
			Duel.ChangeAttackTarget(tc)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(math.ceil(at:GetAttack()/2))
			at:RegisterEffect(e3)
		end
	end
end
