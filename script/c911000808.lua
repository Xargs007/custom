--Hellfire Veil
function c911000808.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	--e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCountLimit(1,911000808)
	e2:SetTarget(c911000808.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--negate attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,911000808)
	e3:SetOperation(c911000808.operation)
	c:RegisterEffect(e3)
end
function c911000808.target(e,c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c911000808.operation(e,tp,eg,ep,ev,re,r,rp)
	--Duel.NegateAttack()
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
